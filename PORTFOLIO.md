# Identity Security Engineer portfolio

Built a personal Microsoft Entra workload-identity lab demonstrating application authentication, effective permission review, credential-expiry detection, and audited retirement.

Migrated a test inventory workload from a client secret to certificate authentication, then rotated the certificate using overlap, replacement validation, original removal, and positive/negative retesting. Correlated a successful workload event with the certificate through a private thumbprint comparison.

Reviewed granted Graph application roles separately from requested permissions. Validated expiry logic with synthetic expired, approaching-expiry, and boundary cases. Treated absent sign-ins as an investigation signal rather than an automatic deletion rule. Disabled a dedicated comparison service principal and verified its audit trail.

Reviewed a disabled AD service-account fixture and searched two lab servers for matching service/task dependencies. Azure managed identity architecture is documented but was not deployed because no enabled subscription was available.

## Resume bullet

Implemented a personal Entra workload-identity lab demonstrating secret-to-certificate migration, certificate rotation, Graph application-role review, expiry checks, and audited service-principal deactivation; documented telemetry limits and a design-only Azure managed-identity architecture.

## Interview discussion

Explain application objects versus service principals, authentication versus authorization, requested versus granted permissions, certificate custody and renewal, token lifetime after credential removal, and why missing sign-ins do not prove no dependencies.

This is a personal lab, not production employment experience. See [results and limitations](docs/validation.md).
