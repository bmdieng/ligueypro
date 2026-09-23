# Architecture cible LigueyPro 2.0

## Domaines
- Identity & Access
- Users / Professionals
- Service Catalog
- Search & Geo
- Requests / Orders
- Messaging
- Payments
- Reviews
- Notifications
- AI Assistant
- Admin / Moderation

## Backend
NestJS + PostgreSQL + Redis.

## API
REST `/v1`, JWT/OAuth2, rate limiting, validation DTO, audit logs.

## Données principales
```text
User
 ├── ProfessionalProfile
 ├── Address
 ├── PaymentMethod
 └── Review

ServiceCategory
 └── Service

ProfessionalProfile
 ├── Services
 ├── Availability
 ├── Documents
 └── Reviews

ServiceRequest
 ├── Customer
 ├── Professional
 ├── Location
 ├── Attachments
 ├── Quote
 ├── Payment
 └── StatusHistory
```

## Statuts ServiceRequest
CREATED -> MATCHING -> ACCEPTED -> EN_ROUTE -> ARRIVED -> IN_PROGRESS -> COMPLETED
                                              \-> CANCELLED

## Sécurité
- TLS
- JWT court + refresh token
- chiffrement des données sensibles
- contrôle RBAC
- validation serveur
- anti-fraude paiement
- logs/audit
- sauvegardes
- protection secrets via vault/secret manager

## IA
L'IA ne décide pas seule du prix ou du diagnostic. Elle assiste :
1. classification de la demande
2. analyse de photo
3. résumé
4. suggestion de professionnels
5. estimation indicative
6. assistant conversationnel
