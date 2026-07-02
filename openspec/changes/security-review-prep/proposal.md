## Why

Before the v1.0 public release, iBuddhism needs a structured security review to identify and remediate potential vulnerabilities — dependency CVEs, insecure local data storage, input injection risks, debug-mode exposure, and reverse-engineering concerns. The app stores user profile data and recitation history locally and uses `image_picker` for photo access, making it important to verify these paths are properly hardened.

## What Changes

- Run dependency vulnerability scan (`flutter pub outdated`, SUPPLY_CHAIN semgrep).
- Audit local storage (shared_preferences, file system) for sensitive data exposure.
- Audit image_picker usage for correct permission handling and temporary file cleanup.
- Add input sanitization / validation checks on text fields (profile name, bio).
- Verify debug-mode assertions are removed or guarded in release builds.
- Add Flutter-specific hardening (obfuscation, code signing review).
- Produce a security report documenting findings and remediations.

## Capabilities

### New Capabilities
- `dependency-vulnerability-scan`: Scan all dependencies for known CVEs and outdated packages.
- `local-storage-audit`: Review what's persisted in shared_preferences and the local file system for sensitive data.
- `image-picker-security-audit`: Verify permission handling, temp file lifecycle, and scope of photo access.
- `input-validation-review`: Audit text input fields for injection or data-integrity risks.
- `release-hardening`: Verify debug-mode guards, obfuscation, code signing, and Flutter release-build best practices.

### Modified Capabilities
*(No existing specs are being modified — all capabilities are new.)*

## Impact

- **pubspec.yaml / lockfile**: Potential dependency upgrades if CVEs are found.
- **Codebase**: Targeted fixes in data persistence, image handling, and text input paths based on audit findings.
- **Build config**: Potential addition of `--obfuscate` and `--split-debug-info` to release build commands.
- **New file**: `SECURITY.md` or security-report artifact in the repo documenting the review.
