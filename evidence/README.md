# Evidence collection and publication

User-provided screenshots were collected during October 21–26, 2026; 18 images have been copied unchanged into this folder. Their existing redactions are preserved. Review each final image before public publication. E01–02 and Azure E09–11 are not included. Use cropped copies of personal-lab screens. Keep originals private. Flatten redactions and inspect the final image before publishing; overlays and blur can be insufficient.

| ID | Screenshot or sanitized result | What it proves |
|---|---|---|
| E01 | Registration overview | Application object exists |
| E02 | Enterprise application overview | Separate service principal; matching client ID |
| E03 | Secret-based API test status | Authentication plus intended operation |
| E04 | Certificate metadata and API status | Certificate method works; no private key shown |
| E05 | Fresh old-secret authentication denial | Old credential removed |
| E06 | Sanitized expiry table | Metadata-based classifications; mark fixture/live |
| E07 | Effective app-role review | Granted permissions and rationale |
| E08 | Workload log filters and covered interval | Observed activity and visibility limits |
| E09 | Managed identity enabled | Azure identity configured |
| E10 | Container-scoped role | Scope of authorization |
| E11 | Read success and other-container denial | Positive and negative authorization tests |
| E12 | Sanitized legacy review and rotation journal | Ownership and lifecycle reasoning |

Remove secret values, access/refresh tokens, QR codes, private keys, account emails, browser profile details, unrelated tabs, tenant domains, subscription/resource IDs, IP addresses, and personal names. Identifiers are not passwords, but consistent aliases keep the portfolio private. Never redact the status code or test meaning. Synthetic outputs must say SYNTHETIC; screenshots of actual lab execution must not be fabricated.

Additional evidence: E06b synthetic cases; E08b bounded absence; E12b account details; E12c LAB-SYNC01 dependency search; E13 deactivation; E14a–c audit status, target, and change; E15 replacement success; E16 rotation retest; E17 final credential state. See [validated results](../docs/validation.md) for limitations.


## Captured evidence files

- [E03-secret-read.png](E03-secret-read.png)
- [E04-certificate-read.png](E04-certificate-read.png)
- [E05-old-secret-failure.png](E05-old-secret-failure.png)
- [E06-live-expiry.png](E06-live-expiry.png)
- [E06b-synthetic.png](E06b-synthetic.png)
- [E07-granted-roles.png](E07-granted-roles.png)
- [E08-workload-event.png](E08-workload-event.png)
- [E08b-no-events.png](E08b-no-events.png)
- [E12-ad-review.png](E12-ad-review.png)
- [E12b-account-details.png](E12b-account-details.png)
- [E12c-sync-dependencies.png](E12c-sync-dependencies.png)
- [E13-disabled.png](E13-disabled.png)
- [E14a-audit-status.png](E14a-audit-status.png)
- [E14b-audit-target.png](E14b-audit-target.png)
- [E14c-audit-change.png](E14c-audit-change.png)
- [E15-replacement.png](E15-replacement.png)
- [E16-retest.png](E16-retest.png)
- [E17-final.png](E17-final.png)

