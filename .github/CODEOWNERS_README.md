# 👥 Code Owners - Anstop

Este documento explica cómo funcionan las revisiones automáticas en el proyecto Anstop mediante GitHub CODEOWNERS.

## 📋 ¿Qué es CODEOWNERS?

CODEOWNERS es un archivo especial de GitHub que define automáticamente quién debe revisar cambios en partes específicas del código. Cuando alguien abre un Pull Request que toca esos archivos, los code owners son **automáticamente solicitados como reviewers**.

## 🔒 Configuración Actual

### Branch Protection Rules (main)

✅ **Status Checks Required:**
- `build-test` debe pasar antes de merge

✅ **Pull Request Reviews:**
- **1 approval requerido** de un code owner
- **Dismiss stale reviews:** Activado (reviews antiguas se descartan en nuevos pushes)
- **Require code owner reviews:** Activado (al menos 1 owner debe aprobar)
- **Require conversation resolution:** Activado (todos los comentarios deben resolverse)

✅ **Branch Rules:**
- ❌ Force push prohibido
- ❌ Deletion prohibido
- ✅ Status checks deben estar actualizados antes de merge

### Code Owners Asignados

| Área | Owner | Descripción |
|------|-------|-------------|
| **Default** | @MoLinesGitHub | Todo el repositorio por defecto |
| **Swift Code** | @MoLinesGitHub | Todos los archivos `.swift` |
| **Xcode Projects** | @MoLinesGitHub | `.xcodeproj` y `.xcworkspace` |
| **CI/CD** | @MoLinesGitHub | `.github/workflows/` |
| **Config Files** | @MoLinesGitHub | `.yml`, `.swiftlint.yml`, `.swiftformat` |
| **Dependencies** | @MoLinesGitHub | `Package.swift`, `.gitmodules` |
| **Documentation** | @MoLinesGitHub | Todos los `.md` |

### 🔴 Áreas Críticas (Requieren Revisión Extra Cuidadosa)

| Ruta | Razón | Owner |
|------|-------|-------|
| `/Anstop/Domain/` | Lógica de negocio central | @MoLinesGitHub |
| `/Anstop/Core/PurchaseManager/` | Sistema de monetización | @MoLinesGitHub |
| `/Anstop/Core/Secrets/` | Datos sensibles (API keys) | @MoLinesGitHub |
| `Configuration.storekit` | Configuración de compras in-app | @MoLinesGitHub |
| `EULA.md` | Términos legales | @MoLinesGitHub |
| `/Anstop/Core/Models/LegalData.swift` | Textos legales | @MoLinesGitHub |

## 🚀 Flujo de Trabajo con CODEOWNERS

### Para Contributors

1. **Crea un branch** desde `main`:
   ```bash
   git checkout -b feature/mi-nueva-feature
   ```

2. **Haz tus cambios** y commit:
   ```bash
   git add .
   git commit -m "feat: descripción del cambio"
   ```

3. **Push a GitHub**:
   ```bash
   git push origin feature/mi-nueva-feature
   ```

4. **Abre un Pull Request**:
   - GitHub **automáticamente** solicitará review a @MoLinesGitHub
   - Si tocas archivos críticos, serás notificado

5. **Espera review**:
   - El code owner debe aprobar el PR
   - CI debe pasar (`build-test` ✅)
   - Todos los comentarios deben resolverse

6. **Merge**:
   - Una vez aprobado, puedes hacer merge a `main`

### Para Code Owners (Maintainers)

1. **Recibirás notificación automática** cuando alguien abra un PR

2. **Revisa el código**:
   - Verifica que sigue las guías de arquitectura
   - Comprueba que los tests pasan
   - Asegúrate de que no rompe funcionalidad existente

3. **Deja comentarios** si hay cambios necesarios

4. **Aprueba el PR** cuando esté listo:
   ```bash
   gh pr review <PR_NUMBER> --approve
   ```

5. **Merge** (o espera que el contributor lo haga):
   ```bash
   gh pr merge <PR_NUMBER> --squash
   ```

## 🛠 Modificar CODEOWNERS

Si necesitas cambiar los owners o añadir nuevas rutas:

1. Edita `.github/CODEOWNERS`

2. Sintaxis:
   ```
   # Comentario
   /ruta/del/archivo.swift @username
   *.txt @username1 @username2
   /carpeta/ @team-name
   ```

3. Commit y push:
   ```bash
   git add .github/CODEOWNERS
   git commit -m "chore: update CODEOWNERS"
   git push origin main
   ```

## 📖 Referencias

- [GitHub Docs - About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [GitHub Docs - Branch protection rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)

---

**Última actualización:** 4 de Diciembre, 2025  
**Mantenido por:** @MoLinesGitHub
