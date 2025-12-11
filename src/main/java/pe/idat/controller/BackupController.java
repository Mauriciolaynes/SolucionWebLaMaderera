package pe.idat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import pe.idat.service.BackupService;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Controlador para gestión de backups de base de datos
 */
@Controller
@RequestMapping("/admin/backup")
public class BackupController {

    @Autowired
    private BackupService backupService;

    /**
     * Muestra la página principal de gestión de backups
     */
    @GetMapping
    public String mostrarPaginaBackup(Model model) {
        try {
            model.addAttribute("backups", backupService.listarBackups());
        } catch (IOException e) {
            model.addAttribute("error", "Error al listar backups: " + e.getMessage());
        }
        return "admin/backup-manager";
    }

    /**
     * Genera un nuevo backup y lo descarga automáticamente
     */
    @PostMapping("/generar")
    public ResponseEntity<Resource> generarYDescargarBackup(RedirectAttributes redirect) {
        try {
            String rutaBackup = backupService.generarBackup();
            Path archivoPath = Paths.get(rutaBackup);

            if (!Files.exists(archivoPath)) {
                throw new IOException("El archivo de backup no se generó correctamente");
            }

            Resource resource = new FileSystemResource(archivoPath);

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION,
                            "attachment; filename=\"" + archivoPath.getFileName().toString() + "\"")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .contentLength(Files.size(archivoPath))
                    .body(resource);

        } catch (IOException e) {
            // Si falla, redirigir con mensaje de error
            redirect.addFlashAttribute("error",
                    "Error al generar backup: " + e.getMessage());
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Descarga un backup existente
     */
    @GetMapping("/descargar/{nombre}")
    public ResponseEntity<Resource> descargarBackup(@PathVariable String nombre) {
        try {
            Path archivoPath = Paths.get("C:/backups_maderera/" + nombre);

            if (!Files.exists(archivoPath)) {
                return ResponseEntity.notFound().build();
            }

            Resource resource = new FileSystemResource(archivoPath);

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION,
                            "attachment; filename=\"" + nombre + "\"")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .contentLength(Files.size(archivoPath))
                    .body(resource);

        } catch (IOException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Restaura la base de datos desde un backup
     */
    @PostMapping("/restaurar")
    public String restaurarBackup(@RequestParam("nombre") String nombre,
            RedirectAttributes redirect) {
        try {
            backupService.restaurarBackup(nombre);
            redirect.addFlashAttribute("success",
                    "✅ Base de datos restaurada correctamente desde: " + nombre);
        } catch (IOException e) {
            redirect.addFlashAttribute("error",
                    "❌ Error al restaurar backup: " + e.getMessage());
        }

        return "redirect:/admin/backup";
    }

    /**
     * Elimina un archivo de backup
     */
    @PostMapping("/eliminar")
    public String eliminarBackup(@RequestParam("nombre") String nombre,
            RedirectAttributes redirect) {
        try {
            backupService.eliminarBackup(nombre);
            redirect.addFlashAttribute("success",
                    "🗑️ Backup eliminado: " + nombre);
        } catch (IOException e) {
            redirect.addFlashAttribute("error",
                    "Error al eliminar backup: " + e.getMessage());
        }

        return "redirect:/admin/backup";
    }
}
