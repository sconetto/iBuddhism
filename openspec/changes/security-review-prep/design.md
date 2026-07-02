## Context

iBuddhism is a single-user offline Flutter app with no network layer, no user accounts, and no authentication. It stores data locally via `shared_preferences` (profile name, bio, avatar color, weekly goal, calendar recitation states) and the device file system (profile photos via `image_picker`). No sensitive credentials, tokens, or PII beyond a user-supplied name and optional photo are stored.

Despite the low-risk profile, a v1.0 release still warrants a systematic security review — dependency CVEs, insecure local storage patterns, input injection, debug-mode exposure, and image-handling edge cases are common Flutter pitfalls that should be ruled out.

## Goals / Non-Goals

**Goals:**
- Identify and fix any known CVEs in project dependencies.
- Confirm `shared_preferences` stores no unintentionally sensitive data.
- Verify `image_picker` usage respects permissions and cleans up temp files.
- Audit text input fields (profile name, bio) for injection or integrity risks.
- Ensure debug-mode code is guarded or absent in release builds.
- Document all findings and remediations in a security report.

**Non-Goals:**
- No penetration testing or runtime exploitation — this is a static review.
- No network/API security review — the app has no network layer.
- No cryptographic audit — no encryption is used or needed for this profile of data.
- No full-codebase threat model — scoped to the five capability areas.

## Decisions

### 1. Tools: `dart pub outdated` + semgrep SUPPLY_CHAIN + manual audit

- **Context**: Dependency vuln scanning for Flutter/Dart is less mature than npm/GitHub Dependabot.
- **Decision**: Use three complementary approaches:
  1. `dart pub outdated` — identify outdated deps with CVEs in release notes.
  2. Semgrep SUPPLY_CHAIN scan — automated known-vuln check for lockfile.
  3. Manual review of each dependency's changelog/security-advisories for recent findings.
- **Rationale**: No single tool covers all Dart/Flutter vulns. Triangulation is pragmatic.
- **Alternative considered**: GitHub Dependabot — not enabled for this repo yet (CI ticket separate).

### 2. Local Storage Audit Scope

- **Context**: `shared_preferences` stores profile fields and calendar states — no credentials or tokens.
- **Decision**: Audit by code inspection — trace every `shared_preferences` read/write call, classify each key's data sensitivity, and flag any key that stores something it shouldn't.
- **Rationale**: Full dump analysis is overkill for 10-15 keys. Code-level trace is sufficient.

### 3. Input Validation: Dart-side sanitization

- **Context**: Profile name and bio are free-text fields from the user.
- **Decision**: Validate length limits and character encoding at the Dart/ViewModel layer before persisting. No HTML/script injection risk in a native mobile app, but guard against excessively large payloads and encoding edge cases.
- **Rationale**: Native Flutter TextFields don't interpret input as code — injection is not a real vector here. Length limits prevent data-integrity issues.

## Risks / Trade-offs

- **[Dependency scan gaps]**: `dart pub outdated` doesn't directly report CVEs — it only shows version recency.
  - **Mitigation**: Supplement with semgrep SUPPLY_CHAIN and manual advisory review.
- **[Low-risk profile may hide edge cases]**: The app has no network/auth, so reviewers may become complacent.
  - **Mitigation**: Explicit checklists for each area; nothing is "obviously safe" without evidence.
- **[No automated security CI]**: This is a one-time review, not continuous.
  - **Mitigation**: Outcomes feed into CI/CD spec (separate change) for ongoing safety.
