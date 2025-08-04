### ERD
```mermaid
erDiagram
users ||--o{ authentications : has
users ||--|| accounts : has
accounts ||--o{ historical_transactions : generates
users ||--o{ historical_transactions : performs
external_services ||--o{ api_keys : has
api_keys ||--o{ api_access_logs : generates
external_services ||--o{ api_access_logs : accesses

    users {
        serial id PK
        varchar username UK "not null unique"
        varchar email UK "not null unique"
        varchar phone UK "not null unique"
        varchar password "not null, hashed"
        timestamp created_at "default now()"
        timestamp updated_at "default now()"
    }

    authentications {
        varchar token PK "512 chars"
        serial user_id FK "references users(id)"
        timestamp created_at "default now()"
    }

    accounts {
        varchar id PK "UUID, default gen_random_uuid()"
        bigint user_id FK "not null unique, references users(id)"
        decimal balance "15,2 precision, default 0.00"
        varchar currency "3 chars, default IDR"
        account_status_enum account_status "ACTIVE,SUSPENDED,CLOSED, default ACTIVE"
        timestamp created_at "default now()"
        timestamp updated_at "default now()"
    }

    historical_transactions {
        varchar id PK "UUID, default gen_random_uuid()"
        bigint user_id FK "not null, references users(id)"
        varchar account_id FK "not null, references accounts(id)"
        varchar transaction_id UK "50 chars, unique"
        transaction_type_enum transaction_type "TOPUP,PAYMENT,REFUND,TRANSFER"
        transaction_status_enum transaction_status "PENDING,SUCCESS,FAILED,CANCELLED"
        decimal amount "15,2 precision, not null"
        decimal balance_before "15,2 precision, not null"
        decimal balance_after "15,2 precision, not null"
        varchar currency "3 chars, default IDR"
        text description "transaction description"
        varchar external_reference "255 chars, external system reference"
        payment_method_enum payment_method "GOPAY,SHOPEE_PAY"
        text metadata "additional transaction data"
        boolean is_accessible_external "default true"
        timestamp created_at "default now()"
        timestamp updated_at "default now()"
    }

    external_services {
        varchar id PK "UUID, default gen_random_uuid()"
        varchar company UK "255 chars, not null unique"
        varchar service_type "50 chars, default HISTORICAL_TRANSACTION"
        varchar contact_email "255 chars, not null"
        text description "service description"
        boolean is_active "default true"
        timestamp created_at "default now()"
        timestamp updated_at "default now()"
    }

    api_keys {
        varchar id PK "UUID, default gen_random_uuid()"
        varchar external_service_id FK "not null unique, references external_services(id)"
        varchar key_name "255 chars, not null"
        permissions_enum permissions "READ_TRANSACTIONS,READ_REPORTS,READ_TRANSACTIONS,READ_REPORTS"
        integer rate_limit_count "optional"
        rate_limit_unit_enum rate_limit_unit "second,minute,hour,day, default minute"
        timestamp expires_at "expiration date, optional"
        boolean is_active "default true"
        timestamp created_at "default now()"
        timestamp updated_at "default now()"
    }

    api_access_logs {
        varchar id PK "UUID, default gen_random_uuid()"
        varchar external_service_id FK "not null, references external_services(id)"
        varchar api_key_id FK "not null, references api_keys(id)"
        varchar endpoint "255 chars, accessed endpoint"
        http_method_enum http_method "GET,POST,PUT,DELETE,PATCH"
        text ip_address "client IP address"
        text user_agent "client user agent"
        integer response_status "HTTP status code"
        timestamp created_at "default now()"
    }
```