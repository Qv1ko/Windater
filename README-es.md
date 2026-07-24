# Windater

Script de automatización de mantenimiento para Windows - actualiza aplicaciones, limpia archivos temporales, desfragmenta discos y instala actualizaciones de Windows.

![Windows 10](https://img.shields.io/badge/Windows-10-3AADEF?style=flat-square&logo=windows&logoColor=white)
![Windows 11](https://img.shields.io/badge/Windows-11-2C74D4?style=flat-square&logo=windows&logoColor=white)
![PowerShell 5.1+](https://img.shields.io/badge/PowerShell-5.1+-131E2A?style=flat-square&logo=powershell&logoColor=white)

### Idioma del README

- 🇪🇸 **Español**
- 🇺🇸 [Inglés](./README.md)

## Características

| Función                         | Descripción                                                                                                   |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| **Actualizar paquetes**         | Actualiza todos los paquetes instalados mediante **winget** (usa **Chocolatey** si winget no está disponible) |
| **Limpiar archivos temporales** | Elimina archivos temporales de `%TEMP%` y `C:\Windows\Temp`                                                   |
| **Desfragmentación**            | Optimiza la unidad C: usando flags avanzados de desfragmentación (`/C /B /G /L /O`)                           |
| **Actualizar Windows**          | Instala el módulo PSWindowsUpdate (si falta) y aplica todas las actualizaciones pendientes de Windows         |

## Requisitos

- **PowerShell 5.1** o superior
- **Privilegios de administrador** (el script se re-lanza como administrador si es necesario)
- **winget** o **Chocolatey** para actualizar paquetes

## Instalación

1. Clona el repositorio:
   ```shell
   git clone https://github.com/Qv1ko/Windater.git
   ```
2. Entra dentro del directorio de Windater
3. Abre PowerShell como administrador y establece la política de ejecución para permitir scripts locales:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## Uso

Ejecuta el script en un terminal de PowerShell como administrador:

```powershell
.\windater.ps1
```
