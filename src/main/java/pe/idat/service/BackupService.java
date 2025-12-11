package pe.idat.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Servicio para gestionar backups y restauración de la base de datos
 */
@Service
public class BackupService {

    @Value("${spring.datasource.url}")
    private String dbUrl;

    @Value("${spring.datasource.username}")
    private String dbUser;

    @Value("${spring.datasource.password}")
    private String dbPassword;

    private static final String BACKUP_DIR = "C:/backups_maderera/";

    // Rutas comunes de MySQL en Windows
    private static final String[] POSIBLES_RUTAS_MYSQL = {
            "C:/Program Files/MySQL/MySQL Server 8.0/bin/",
            "C:/Program Files/MySQL/MySQL Server 8.4/bin/",
            "C:/Program Files/MySQL/MySQL Server 9.0/bin/",
            "C:/xampp/mysql/bin/",
            "C:/wamp64/bin/mysql/mysql8.0.27/bin/"
    };

    /**
     * Genera un backup de la base de datos usando mysqldump
     * 
     * @return Ruta del archivo generado
     */
    public String generarBackup() throws IOException {
        // Crear directorio si no existe
        Files.createDirectories(Paths.get(BACKUP_DIR));

        // Nombre del archivo con timestamp
        String timestamp = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss"));
        String nombreArchivo = "backup_" + timestamp + ".sql";
        String rutaCompleta = BACKUP_DIR + nombreArchivo;

        // Extraer nombre de BD
        String dbName = extraerNombreBaseDatos(dbUrl);

        // Encontrar ruta de mysqldump
        String mysqldumpPath = encontrarComandoMySQL("mysqldump.exe");
        if (mysqldumpPath == null) {
            throw new IOException("No se encontró mysqldump. Verifica que MySQL esté instalado.");
        }

        // Comando mysqldump
        String[] comando = {
                mysqldumpPath,
                "--user=" + dbUser,
                "--password=" + dbPassword,
                "--databases", dbName,
                "--result-file=" + rutaCompleta,
                "--routines",
                "--triggers",
                "--single-transaction",
                "--quick"
        };

        // Ejecutar proceso
        ProcessBuilder pb = new ProcessBuilder(comando);
        pb.redirectErrorStream(true);
        Process proceso = pb.start();

        // Capturar salida para debugging
        StringBuilder output = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(proceso.getInputStream()))) {
            String linea;
            while ((linea = reader.readLine()) != null) {
                output.append(linea).append("\n");
            }
        }

        try {
            int exitCode = proceso.waitFor();
            if (exitCode != 0) {
                throw new IOException("Error al generar backup. Exit code: " + exitCode +
                        "\nOutput: " + output.toString());
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IOException("Proceso interrumpido");
        }

        return rutaCompleta;
    }

    /**
     * Restaura un backup desde un archivo
     * 
     * @param nombreArchivo Nombre del archivo de backup
     */
    public void restaurarBackup(String nombreArchivo) throws IOException {
        String rutaArchivo = BACKUP_DIR + nombreArchivo;

        // Validar que el archivo existe
        if (!Files.exists(Paths.get(rutaArchivo))) {
            throw new FileNotFoundException("Archivo de backup no encontrado: " + nombreArchivo);
        }

        String dbName = extraerNombreBaseDatos(dbUrl);

        // Encontrar ruta de mysql
        String mysqlPath = encontrarComandoMySQL("mysql.exe");
        if (mysqlPath == null) {
            throw new IOException("No se encontró mysql. Verifica que MySQL esté instalado.");
        }

        // Comando mysql
        String[] comando = {
                mysqlPath,
                "--user=" + dbUser,
                "--password=" + dbPassword,
                dbName
        };

        ProcessBuilder pb = new ProcessBuilder(comando);
        pb.redirectInput(new File(rutaArchivo));
        pb.redirectErrorStream(true);

        Process proceso = pb.start();

        // Capturar salida
        StringBuilder output = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(proceso.getInputStream()))) {
            String linea;
            while ((linea = reader.readLine()) != null) {
                output.append(linea).append("\n");
            }
        }

        try {
            int exitCode = proceso.waitFor();
            if (exitCode != 0) {
                throw new IOException("Error al restaurar backup. Exit code: " + exitCode +
                        "\nOutput: " + output.toString());
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IOException("Proceso interrumpido");
        }
    }

    /**
     * Lista todos los backups disponibles ordenados por fecha (más reciente
     * primero)
     */
    public List<BackupInfo> listarBackups() throws IOException {
        Path dirPath = Paths.get(BACKUP_DIR);

        if (!Files.exists(dirPath)) {
            Files.createDirectories(dirPath);
            return new ArrayList<>();
        }

        return Files.list(dirPath)
                .filter(path -> path.toString().endsWith(".sql"))
                .map(path -> {
                    try {
                        BackupInfo info = new BackupInfo();
                        info.setNombre(path.getFileName().toString());
                        info.setTamano(Files.size(path));
                        info.setFechaCreacion(Files.getLastModifiedTime(path)
                                .toInstant()
                                .toString());
                        return info;
                    } catch (IOException e) {
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .sorted((a, b) -> b.getFechaCreacion().compareTo(a.getFechaCreacion()))
                .collect(Collectors.toList());
    }

    /**
     * Elimina un archivo de backup
     */
    public void eliminarBackup(String nombreArchivo) throws IOException {
        Path rutaArchivo = Paths.get(BACKUP_DIR + nombreArchivo);

        if (!Files.exists(rutaArchivo)) {
            throw new FileNotFoundException("Archivo no encontrado: " + nombreArchivo);
        }

        Files.delete(rutaArchivo);
    }

    /**
     * Busca el comando de MySQL en las rutas comunes
     */
    private String encontrarComandoMySQL(String nombreComando) {
        for (String ruta : POSIBLES_RUTAS_MYSQL) {
            File archivo = new File(ruta + nombreComando);
            if (archivo.exists()) {
                return archivo.getAbsolutePath();
            }
        }
        return null;
    }

    /**
     * Extrae el nombre de la base de datos de la URL JDBC
     * Ejemplo: jdbc:mysql://localhost:3306/nombre_db?params -> nombre_db
     */
    private String extraerNombreBaseDatos(String url) {
        String[] partes = url.split("/");
        String nombreConParametros = partes[partes.length - 1];
        return nombreConParametros.split("\\?")[0];
    }

    /**
     * Clase para almacenar información de un backup
     */
    public static class BackupInfo {
        private String nombre;
        private long tamano;
        private String fechaCreacion;

        public String getNombre() {
            return nombre;
        }

        public void setNombre(String nombre) {
            this.nombre = nombre;
        }

        public long getTamano() {
            return tamano;
        }

        public void setTamano(long tamano) {
            this.tamano = tamano;
        }

        public String getFechaCreacion() {
            return fechaCreacion;
        }

        public void setFechaCreacion(String fechaCreacion) {
            this.fechaCreacion = fechaCreacion;
        }

        /**
         * Retorna el tamaño formateado en una unidad legible
         */
        public String getTamanoFormatado() {
            if (tamano < 1024) {
                return tamano + " B";
            } else if (tamano < 1024 * 1024) {
                return String.format("%.2f KB", tamano / 1024.0);
            } else {
                return String.format("%.2f MB", tamano / (1024.0 * 1024.0));
            }
        }

        /**
         * Retorna la fecha formateada de forma legible
         */
        public String getFechaFormateada() {
            // Formato ISO: 2025-12-10T20:30:00Z
            try {
                return fechaCreacion.substring(0, 19).replace("T", " ");
            } catch (Exception e) {
                return fechaCreacion;
            }
        }
    }
}
