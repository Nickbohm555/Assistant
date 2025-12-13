# AI Assistant Architecture Documentation

## Table of Contents

1. [System Overview](#system-overview)
2. [Technology Stack](#technology-stack)
3. [High-Level Architecture](#high-level-architecture)
4. [Component Architecture](#component-architecture)
5. [Agent System](#agent-system)
6. [Data Flow](#data-flow)
7. [Service Integrations](#service-integrations)
8. [Deployment Architecture](#deployment-architecture)
9. [Development Workflow](#development-workflow)

---

## System Overview

The AI Assistant is a comprehensive, multi-agent system designed to handle a wide variety of tasks through specialized DeepAgents coordinated by a LangGraph-based supervisor. The system uses an asynchronous message-driven architecture built on FastStream and RabbitMQ, with a modern React frontend and FastAPI backend.

### Key Features

- **Multi-Agent Orchestration**: Supervisor pattern with specialized DeepAgents
- **Email Integration**: Full Gmail API integration for email management
- **Browser Automation**: Playwright-based browser control for trend finding and web interaction
- **Async Processing**: FastStream workers for scalable task processing
- **Real-time Updates**: WebSocket connections for live task updates
- **Comprehensive Memory**: Vector stores and graph memory for context retention

---

## Technology Stack

### Backend

| Technology | Purpose | Version |
|------------|---------|---------|
| **Python** | Primary backend language | 3.11+ |
| **FastAPI** | REST API and WebSocket server | Latest |
| **FastStream** | Async message processing framework | Latest |
| **RabbitMQ** | Message broker for agent communication | 3.12+ |
| **LangGraph** | Agent orchestration and state management | Latest |
| **SQLAlchemy** | ORM for database operations | 2.0+ |
| **PostgreSQL** | Primary database for metadata | 15+ |
| **Redis** | Caching, sessions, and pub/sub | 7+ |
| **OAuth 2.0** | Authentication and authorization | - |
| **Poetry** | Dependency management | Latest |
| **Docker** | Containerization | Latest |
| **Kubernetes** | Container orchestration | 1.28+ |
| **Argo CD** | GitOps deployment | Latest |
| **GitHub Actions** | CI/CD pipeline | - |

### Frontend

| Technology | Purpose | Version |
|------------|---------|---------|
| **React** | UI framework | 18+ |
| **TypeScript** | Type-safe JavaScript | 5+ |
| **Vite** | Build tool and dev server | Latest |
| **Material UI (MUI)** | Component library | 5+ |
| **React Query** | Server state management | 5+ |
| **Axios** | HTTP client | Latest |

### External Services

| Service | Purpose |
|---------|---------|
| **Gmail API** | Email access and management |
| **Playwright** | Browser automation and trend finding |

---

## High-Level Architecture

```mermaid
graph TB
    subgraph Frontend["Frontend Layer"]
        React["React + TypeScript"]
        MUI["Material UI"]
        RQ["React Query"]
        Axios["Axios Client"]
    end

    subgraph API["API Gateway"]
        FastAPI["FastAPI Server"]
        OAuth["OAuth 2.0"]
        WS["WebSocket"]
    end

    subgraph Queue["Message Broker"]
        RabbitMQ["RabbitMQ"]
    end

    subgraph Workers["FastStream Workers"]
        Supervisor["Supervisor Worker<br/>LangGraph"]
        CodeAgent["Code Agent"]
        ResearchAgent["Research Agent"]
        DataAgent["Data Agent"]
        EmailAgent["Email Agent"]
        BrowserAgent["Browser Agent"]
    end

    subgraph Storage["Storage Layer"]
        Postgres["PostgreSQL<br/>SQLAlchemy"]
        Redis["Redis Cache"]
    end

    subgraph External["External Services"]
        GmailAPI["Gmail API"]
        Playwright["Playwright Browser"]
    end

    React --> MUI
    React --> RQ
    RQ --> Axios
    Axios --> FastAPI
    React --> WS
    WS --> FastAPI

    FastAPI --> OAuth
    FastAPI --> RabbitMQ
    FastAPI --> Postgres
    FastAPI --> Redis

    RabbitMQ --> Supervisor
    Supervisor --> CodeAgent
    Supervisor --> ResearchAgent
    Supervisor --> DataAgent
    Supervisor --> EmailAgent
    Supervisor --> BrowserAgent

    EmailAgent --> GmailAPI
    BrowserAgent --> Playwright

    CodeAgent --> Redis
    ResearchAgent --> Redis
    DataAgent --> Redis
    EmailAgent --> Redis
    BrowserAgent --> Redis

    Workers --> Postgres
```

---

## Component Architecture

### Frontend Architecture

```mermaid
graph LR
    subgraph App["React Application"]
        Layout["App Layout"]
        Chat["Chat Interface"]
        Monitor["Agent Monitor"]
        Tasks["Task Tracker"]
        Memory["Memory View"]
    end

    subgraph State["State Management"]
        RQStore["React Query"]
        AuthStore["Auth Store"]
    end

    subgraph Services["Services"]
        ApiService["API Service<br/>Axios"]
        WSService["WebSocket Service"]
        AuthService["OAuth Service"]
    end

    Layout --> Chat
    Layout --> Monitor
    Layout --> Tasks
    Layout --> Memory

    Chat --> RQStore
    Monitor --> RQStore
    Tasks --> RQStore
    Memory --> RQStore

    RQStore --> ApiService
    RQStore --> WSService
    AuthStore --> AuthService

    ApiService --> FastAPI["FastAPI Backend"]
    WSService --> FastAPI
    AuthService --> FastAPI
```

### Backend Architecture

```mermaid
graph TB
    subgraph FastAPIApp["FastAPI Application"]
        Routes["API Routes"]
        Middleware["Middleware"]
        Dependencies["Dependencies"]
    end

    subgraph Core["Core Services"]
        SupervisorCore["Supervisor Orchestrator"]
        Router["Intent Router"]
        StateMgr["State Manager"]
    end

    subgraph Agents["DeepAgents"]
        CodeDA["Code DeepAgent"]
        ResearchDA["Research DeepAgent"]
        DataDA["Data DeepAgent"]
        EmailDA["Email DeepAgent"]
        BrowserDA["Browser DeepAgent"]
    end

    subgraph Tools["Agent Tools"]
        FileTools["File System"]
        CodeTools["Code Execution"]
        WebTools["Web Search"]
        EmailTools["Gmail API"]
        BrowserTools["Playwright"]
    end

    Routes --> Middleware
    Middleware --> Dependencies
    Dependencies --> SupervisorCore
    SupervisorCore --> Router
    Router --> StateMgr
    Router --> Agents

    CodeDA --> CodeTools
    CodeDA --> FileTools
    ResearchDA --> WebTools
    DataDA --> CodeTools
    EmailDA --> EmailTools
    BrowserDA --> BrowserTools
```

---

## Agent System

### Supervisor Pattern

The system uses a hierarchical supervisor pattern where a LangGraph-based supervisor coordinates multiple DeepAgents, each specializing in different domains.

```mermaid
graph TD
    User["User Request"] --> Supervisor["LangGraph Supervisor"]
    
    Supervisor --> IntentAnalysis["Intent Analysis"]
    IntentAnalysis --> Router["Agent Router"]
    
    Router --> CodeAgent["Code DeepAgent"]
    Router --> ResearchAgent["Research DeepAgent"]
    Router --> DataAgent["Data DeepAgent"]
    Router --> EmailAgent["Email DeepAgent"]
    Router --> BrowserAgent["Browser DeepAgent"]
    
    CodeAgent --> CodeSub1["Code Analyzer"]
    CodeAgent --> CodeSub2["Code Writer"]
    CodeAgent --> CodeSub3["Code Debugger"]
    
    ResearchAgent --> ResearchSub1["Searcher"]
    ResearchAgent --> ResearchSub2["Summarizer"]
    ResearchAgent --> ResearchSub3["Validator"]
    
    DataAgent --> DataSub1["Data Processor"]
    DataAgent --> DataSub2["Data Visualizer"]
    DataAgent --> DataSub3["Data Analyzer"]
    
    EmailAgent --> EmailSub1["Email Reader"]
    EmailAgent --> EmailSub2["Email Composer"]
    EmailAgent --> EmailSub3["Email Analyzer"]
    
    BrowserAgent --> BrowserSub1["Browser Controller"]
    BrowserAgent --> BrowserSub2["Trend Finder"]
    BrowserAgent --> BrowserSub3["Data Extractor"]
    
    CodeSub1 --> Aggregator["Result Aggregator"]
    CodeSub2 --> Aggregator
    CodeSub3 --> Aggregator
    ResearchSub1 --> Aggregator
    ResearchSub2 --> Aggregator
    ResearchSub3 --> Aggregator
    DataSub1 --> Aggregator
    DataSub2 --> Aggregator
    DataSub3 --> Aggregator
    EmailSub1 --> Aggregator
    EmailSub2 --> Aggregator
    EmailSub3 --> Aggregator
    BrowserSub1 --> Aggregator
    BrowserSub2 --> Aggregator
    BrowserSub3 --> Aggregator
    
    Aggregator --> Response["Final Response"]
```

### DeepAgent: Email Agent

The Email Agent provides comprehensive email management capabilities through Gmail API integration.

#### Structure

- **Main Agent**: Email DeepAgent
- **Queue**: `agent.email` (RabbitMQ)
- **Tools**: Gmail API wrapper, email parsing utilities

#### Subagents

1. **Email Reader Subagent**
   - Fetches emails from Gmail API
   - Parses email content (subject, body, attachments)
   - Filters and searches emails
   - Retrieves email metadata

2. **Email Composer Subagent**
   - Creates email drafts
   - Formats email content
   - Attaches files
   - Sends emails via Gmail API

3. **Email Analyzer Subagent**
   - Analyzes email content and sentiment
   - Identifies important emails
   - Extracts actionable items
   - Categorizes emails

#### Email Agent Workflow

```mermaid
sequenceDiagram
    participant User
    participant FastAPI
    participant RabbitMQ
    participant EmailAgent
    participant GmailAPI
    participant Redis

    User->>FastAPI: Request email operation
    FastAPI->>RabbitMQ: Publish to agent.email
    RabbitMQ->>EmailAgent: Consume task
    
    alt Read Email
        EmailAgent->>EmailAgent: Email Reader Subagent
        EmailAgent->>GmailAPI: Fetch emails
        GmailAPI-->>EmailAgent: Email data
        EmailAgent->>Redis: Cache results
    else Compose Email
        EmailAgent->>EmailAgent: Email Composer Subagent
        EmailAgent->>GmailAPI: Create/Send email
        GmailAPI-->>EmailAgent: Confirmation
    else Analyze Email
        EmailAgent->>EmailAgent: Email Analyzer Subagent
        EmailAgent->>Redis: Get cached emails
        EmailAgent->>EmailAgent: Analyze content
    end
    
    EmailAgent->>RabbitMQ: Publish results
    RabbitMQ->>FastAPI: Results queue
    FastAPI->>User: Stream response
```

#### Gmail API Integration

- **Authentication**: OAuth 2.0 with refresh token management
- **Scopes**: 
  - `gmail.readonly` - Read emails
  - `gmail.send` - Send emails
  - `gmail.modify` - Modify emails
- **Storage**: OAuth tokens stored securely in PostgreSQL
- **Caching**: Email metadata cached in Redis for quick access

### DeepAgent: Browser Agent

The Browser Agent provides browser automation capabilities using Playwright for trend finding, web scraping, and interactive web tasks.

#### Structure

- **Main Agent**: Browser DeepAgent
- **Queue**: `agent.browser` (RabbitMQ)
- **Tools**: Playwright browser automation, web scraping utilities

#### Subagents

1. **Browser Controller Subagent**
   - Launches and manages browser instances
   - Navigates to URLs
   - Interacts with page elements (click, type, scroll)
   - Handles authentication flows
   - Manages browser sessions

2. **Trend Finder Subagent**
   - Searches for trends on social media platforms
   - Analyzes trending topics
   - Monitors specific websites for updates
   - Tracks keyword trends over time
   - Generates trend reports

3. **Data Extractor Subagent**
   - Extracts structured data from web pages
   - Scrapes content following ethical guidelines
   - Parses HTML/JSON content
   - Handles dynamic content (SPA)
   - Saves extracted data

#### Browser Agent Workflow

```mermaid
sequenceDiagram
    participant User
    participant FastAPI
    participant RabbitMQ
    participant BrowserAgent
    participant Playwright
    participant Redis

    User->>FastAPI: Request browser operation
    FastAPI->>RabbitMQ: Publish to agent.browser
    RabbitMQ->>BrowserAgent: Consume task
    
    BrowserAgent->>Playwright: Launch browser instance
    
    alt Navigate & Control
        BrowserAgent->>BrowserAgent: Browser Controller Subagent
        BrowserAgent->>Playwright: Navigate to URL
        BrowserAgent->>Playwright: Interact with page
        Playwright-->>BrowserAgent: Page state
    else Find Trends
        BrowserAgent->>BrowserAgent: Trend Finder Subagent
        BrowserAgent->>Playwright: Navigate to trend sources
        BrowserAgent->>BrowserAgent: Analyze trends
        BrowserAgent->>Redis: Cache trend data
    else Extract Data
        BrowserAgent->>BrowserAgent: Data Extractor Subagent
        BrowserAgent->>Playwright: Load page
        BrowserAgent->>BrowserAgent: Extract structured data
        BrowserAgent->>Redis: Store extracted data
    end
    
    BrowserAgent->>Playwright: Close browser
    BrowserAgent->>RabbitMQ: Publish results
    RabbitMQ->>FastAPI: Results queue
    FastAPI->>User: Stream response
```

#### Playwright Integration

- **Browser Types**: Chromium, Firefox, WebKit
- **Mode**: Headless by default, can run with UI for debugging
- **Session Management**: Browser sessions cached in Redis
- **Resource Limits**: CPU and memory limits per browser instance
- **Concurrency**: Multiple browser instances for parallel processing

### Other DeepAgents

#### Code Agent
- **Queue**: `agent.code`
- **Subagents**: Code Analyzer, Code Writer, Code Debugger
- **Tools**: File system access, code execution, linters

#### Research Agent
- **Queue**: `agent.research`
- **Subagents**: Searcher, Summarizer, Validator
- **Tools**: Web search APIs, content parsing

#### Data Agent
- **Queue**: `agent.data`
- **Subagents**: Data Processor, Data Visualizer, Data Analyzer
- **Tools**: Data processing libraries, visualization tools

---

## Data Flow

### Request Flow with FastStream and RabbitMQ

```mermaid
sequenceDiagram
    participant User
    participant React
    participant FastAPI
    participant RabbitMQ
    participant Supervisor
    participant DeepAgent
    participant Tools
    participant Redis
    participant Postgres

    User->>React: Submit request
    React->>FastAPI: POST /api/v1/chat (Axios)
    FastAPI->>Postgres: Create task record (SQLAlchemy)
    FastAPI->>RabbitMQ: Publish to supervisor.tasks
    FastAPI-->>React: Return task_id
    
    RabbitMQ->>Supervisor: Consume task (FastStream)
    Supervisor->>Supervisor: LangGraph routing
    Supervisor->>RabbitMQ: Publish to agent.{type}
    
    RabbitMQ->>DeepAgent: Consume task (FastStream)
    DeepAgent->>Redis: Check cache
    alt Cache Miss
        DeepAgent->>Tools: Execute task
        Tools-->>DeepAgent: Results
        DeepAgent->>Redis: Cache results
    else Cache Hit
        Redis-->>DeepAgent: Cached results
    end
    
    DeepAgent->>RabbitMQ: Publish to agent.results
    RabbitMQ->>Aggregator: Consume results (FastStream)
    Aggregator->>Postgres: Update task status
    Aggregator->>Redis: Store results
    
    FastAPI->>Redis: Poll for results
    FastAPI->>React: WebSocket update
    React->>React: React Query update
    React->>User: Display results
```

### Message Queue Architecture

```mermaid
graph TB
    subgraph Exchanges["RabbitMQ Exchanges"]
        SupervisorEx["supervisor Exchange"]
        AgentEx["agent Exchange"]
        ResultsEx["results Exchange"]
    end

    subgraph Queues["Queues"]
        SupervisorQ["supervisor.tasks"]
        CodeQ["agent.code"]
        ResearchQ["agent.research"]
        DataQ["agent.data"]
        EmailQ["agent.email"]
        BrowserQ["agent.browser"]
        ResultsQ["agent.results"]
    end

    SupervisorEx --> SupervisorQ
    AgentEx --> CodeQ
    AgentEx --> ResearchQ
    AgentEx --> DataQ
    AgentEx --> EmailQ
    AgentEx --> BrowserQ
    ResultsEx --> ResultsQ

    SupervisorQ --> SupervisorWorker["Supervisor Worker"]
    CodeQ --> CodeWorker["Code Agent Worker"]
    ResearchQ --> ResearchWorker["Research Agent Worker"]
    DataQ --> DataWorker["Data Agent Worker"]
    EmailQ --> EmailWorker["Email Agent Worker"]
    BrowserQ --> BrowserWorker["Browser Agent Worker"]
    ResultsQ --> AggregatorWorker["Aggregator Worker"]
```

---

## Service Integrations

### RabbitMQ Configuration

**Exchanges:**
- `supervisor` (direct) - Routes tasks to supervisor
- `agent` (topic) - Routes tasks to specific agents
- `results` (fanout) - Distributes results to aggregators

**Queues:**
- `supervisor.tasks` - Supervisor input queue
- `agent.code` - Code agent queue
- `agent.research` - Research agent queue
- `agent.data` - Data agent queue
- `agent.email` - Email agent queue
- `agent.browser` - Browser agent queue
- `agent.results` - Results aggregation queue

**Message Durability:**
- All queues are durable
- Messages are persisted to disk
- Acknowledgment required for message processing

### Redis Configuration

**Usage Patterns:**
- **Session Storage**: User sessions and OAuth tokens
- **Result Caching**: Agent results with TTL
- **Browser Sessions**: Active Playwright sessions
- **Rate Limiting**: Request rate limiting counters
- **Pub/Sub**: Real-time updates to WebSocket clients

**Key Patterns:**
- `session:{user_id}` - User session data
- `task:{task_id}` - Task results
- `cache:{agent}:{key}` - Agent-specific cache
- `browser:{session_id}` - Browser session metadata
- `rate_limit:{user_id}:{endpoint}` - Rate limit counters

### PostgreSQL Schema

**Tables:**
- `users` - User accounts and OAuth credentials
- `tasks` - Task metadata and status
- `conversations` - Conversation history
- `agent_configs` - Agent configurations
- `email_metadata` - Email metadata cache
- `browser_history` - Browser search history
- `memory_vectors` - Vector embeddings for memory

**Relationships:**
- Users have many tasks
- Tasks belong to conversations
- Tasks have agent configurations
- Users have email metadata

### OAuth 2.0 Integration

**Providers:**
- Main application OAuth (for user authentication)
- Gmail API OAuth (for email access)

**Flow:**
1. User initiates OAuth flow
2. Redirect to OAuth provider
3. User authorizes application
4. Receive authorization code
5. Exchange code for access/refresh tokens
6. Store tokens securely in PostgreSQL
7. Use access token for API calls
8. Refresh tokens automatically when expired

**Token Management:**
- Access tokens: Short-lived, stored in Redis
- Refresh tokens: Long-lived, stored encrypted in PostgreSQL
- Automatic token refresh via background workers

### Gmail API Integration

**Authentication:**
- OAuth 2.0 with refresh token flow
- Scopes: `gmail.readonly`, `gmail.send`, `gmail.modify`
- Service account support for organization-wide access

**Operations:**
- List messages (with filters)
- Get message details
- Send messages
- Create drafts
- Modify labels
- Search messages

**Rate Limits:**
- 1 billion quota units per day
- Per-user rate limits
- Exponential backoff for rate limit errors

### Playwright Integration

**Browser Management:**
- Headless mode by default
- Browser instances managed per worker
- Session persistence in Redis
- Automatic cleanup of unused instances

**Capabilities:**
- Multi-browser support (Chromium, Firefox, WebKit)
- Screenshot capture
- PDF generation
- Network interception
- Device emulation

**Resource Management:**
- CPU and memory limits per instance
- Maximum concurrent instances per worker
- Automatic instance recycling
- Browser cache management

---

## Deployment Architecture

### Kubernetes Architecture

```mermaid
graph TB
    subgraph Ingress["Ingress Layer"]
        NGINX["NGINX Ingress"]
    end

    subgraph API["API Layer"]
        FastAPIDep["FastAPI Deployment<br/>replicas: 3<br/>HPA enabled"]
        FastAPISvc["FastAPI Service<br/>LoadBalancer"]
    end

    subgraph Workers["Worker Layer"]
        SupervisorDep["Supervisor Deployment<br/>replicas: 1"]
        CodeAgentDep["Code Agent Deployment<br/>replicas: 2"]
        ResearchAgentDep["Research Agent Deployment<br/>replicas: 2"]
        DataAgentDep["Data Agent Deployment<br/>replicas: 2"]
        EmailAgentDep["Email Agent Deployment<br/>replicas: 2"]
        BrowserAgentDep["Browser Agent Deployment<br/>replicas: 2"]
        AggregatorDep["Aggregator Deployment<br/>replicas: 1"]
    end

    subgraph Storage["Storage Layer"]
        PostgresSS["PostgreSQL StatefulSet<br/>replicas: 1<br/>Persistent Volume"]
        RedisSS["Redis StatefulSet<br/>replicas: 3<br/>Sentinel Mode"]
        RabbitMQSS["RabbitMQ StatefulSet<br/>replicas: 3<br/>Clustering"]
    end

    subgraph Frontend["Frontend Layer"]
        ReactDep["React Deployment<br/>replicas: 3"]
        ReactSvc["React Service<br/>NodePort"]
    end

    subgraph GitOps["GitOps Layer"]
        ArgoCD["Argo CD<br/>Application Controller"]
    end

    NGINX --> FastAPISvc
    NGINX --> ReactSvc
    FastAPISvc --> FastAPIDep
    FastAPIDep --> PostgresSS
    FastAPIDep --> RedisSS
    FastAPIDep --> RabbitMQSS
    
    SupervisorDep --> RabbitMQSS
    SupervisorDep --> RedisSS
    CodeAgentDep --> RabbitMQSS
    ResearchAgentDep --> RabbitMQSS
    DataAgentDep --> RabbitMQSS
    EmailAgentDep --> RabbitMQSS
    BrowserAgentDep --> RabbitMQSS
    AggregatorDep --> RabbitMQSS

    Workers --> PostgresSS
    Workers --> RedisSS

    ArgoCD --> FastAPIDep
    ArgoCD --> ReactDep
    ArgoCD --> Workers
```

### Deployment Components

#### FastAPI Deployment
- **Replicas**: 3 (auto-scales with HPA)
- **Resources**: 512Mi memory, 500m CPU per pod
- **Health Checks**: Liveness and readiness probes
- **Service**: LoadBalancer with external IP
- **ConfigMaps**: Environment variables, API keys
- **Secrets**: OAuth credentials, database passwords

#### FastStream Worker Deployments
- **Supervisor**: 1 replica (singleton)
- **Code Agent**: 2 replicas (horizontal scaling)
- **Research Agent**: 2 replicas
- **Data Agent**: 2 replicas
- **Email Agent**: 2 replicas
- **Browser Agent**: 2 replicas (resource-intensive)
- **Aggregator**: 1 replica

#### Stateful Services

**PostgreSQL:**
- StatefulSet with persistent volume
- Single primary replica
- Automated backups
- Connection pooling via PgBouncer

**Redis:**
- StatefulSet with 3 replicas
- Sentinel mode for high availability
- Persistent storage
- Memory limits configured

**RabbitMQ:**
- StatefulSet with 3 replicas
- Clustering enabled
- Mirrored queues for durability
- Management UI exposed

### Argo CD Configuration

**Applications:**
- `backend-app` - FastAPI and workers
- `frontend-app` - React application
- `infrastructure-app` - Storage services

**Sync Policy:**
- Automatic sync from Git repository
- Self-healing (automatically corrects drift)
- Prune resources (removes deleted resources)
- Sync windows configured for production

**Health Monitoring:**
- Application health status
- Sync status tracking
- Rollback capabilities
- Notifications on failures

### GitHub Actions CI/CD

```mermaid
graph LR
    subgraph GitHub["GitHub Repository"]
        Push["Push to Branch"]
    end

    subgraph CI["CI Pipeline"]
        Test["Run Tests"]
        Lint["Code Linting"]
        Build["Build Docker Images"]
        PushRegistry["Push to Registry"]
    end

    subgraph CD["CD Pipeline"]
        ArgoCD["Argo CD Sync"]
        Deploy["Deploy to K8s"]
        Verify["Health Checks"]
    end

    Push --> Test
    Test --> Lint
    Lint --> Build
    Build --> PushRegistry
    PushRegistry --> ArgoCD
    ArgoCD --> Deploy
    Deploy --> Verify
```

#### CI/CD Workflow

1. **On Push to Main/Branch:**
   - Run backend tests (Poetry + pytest)
   - Run frontend tests (npm test)
   - Run linting (flake8, eslint)
   - Run type checking (mypy, tsc)

2. **Build Stage:**
   - Build backend Docker image
   - Build frontend Docker image
   - Tag images with commit SHA
   - Push to container registry

3. **Deploy Stage:**
   - Trigger Argo CD sync
   - Update Kubernetes manifests
   - Deploy to staging environment
   - Run smoke tests

4. **Production Promotion:**
   - Manual approval required
   - Deploy to production
   - Monitor deployment health
   - Rollback on failure

---

## Development Workflow

### Local Development Setup

#### Prerequisites
- Docker and Docker Compose
- Python 3.11+ with Poetry
- Node.js 18+ with npm
- Git

#### Setup Steps

1. **Clone Repository**
   ```bash
   git clone <repository-url>
   cd Assistant
   ```

2. **Start Infrastructure**
   ```bash
   docker-compose up -d postgresql redis rabbitmq
   ```

3. **Backend Setup**
   ```bash
   cd backend
   poetry install
   poetry run alembic upgrade head
   poetry run uvicorn app.main:app --reload
   ```

4. **Frontend Setup**
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

5. **Start Workers**
   ```bash
   cd backend
   poetry run faststream run workers.supervisor_worker
   poetry run faststream run workers.code_agent_worker
   # ... other workers
   ```

### Project Structure

```
Assistant/
├── backend/
│   ├── app/
│   │   ├── api/
│   │   │   ├── routes/
│   │   │   │   ├── auth.py
│   │   │   │   ├── chat.py
│   │   │   │   ├── agents.py
│   │   │   │   └── tasks.py
│   │   │   └── websocket.py
│   │   ├── core/
│   │   │   ├── supervisor/
│   │   │   ├── agents/
│   │   │   └── tools/
│   │   ├── db/
│   │   │   └── models/
│   │   ├── services/
│   │   │   ├── redis.py
│   │   │   ├── rabbitmq.py
│   │   │   ├── gmail.py
│   │   │   └── playwright.py
│   │   └── utils/
│   ├── workers/
│   │   ├── supervisor_worker.py
│   │   ├── code_agent_worker.py
│   │   ├── research_agent_worker.py
│   │   ├── data_agent_worker.py
│   │   ├── email_agent_worker.py
│   │   ├── browser_agent_worker.py
│   │   └── aggregator_worker.py
│   ├── tests/
│   ├── pyproject.toml
│   └── Dockerfile
│
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── services/
│   │   ├── hooks/
│   │   ├── stores/
│   │   └── types/
│   ├── package.json
│   ├── vite.config.ts
│   └── Dockerfile
│
├── k8s/
│   ├── deployments/
│   ├── services/
│   └── configmaps/
│
├── argo/
│   └── applications/
│
├── .github/
│   └── workflows/
│
├── docker-compose.yml
└── ARCHITECTURE.md
```

### Environment Variables

**Backend (.env):**
```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost/dbname

# Redis
REDIS_URL=redis://localhost:6379

# RabbitMQ
RABBITMQ_URL=amqp://guest:guest@localhost:5672

# OAuth
OAUTH_CLIENT_ID=your_client_id
OAUTH_CLIENT_SECRET=your_client_secret

# Gmail API
GMAIL_CLIENT_ID=your_gmail_client_id
GMAIL_CLIENT_SECRET=your_gmail_client_secret

# API Keys
OPENAI_API_KEY=your_openai_key
ANTHROPIC_API_KEY=your_anthropic_key
```

**Frontend (.env):**
```bash
VITE_API_URL=http://localhost:8000
VITE_WS_URL=ws://localhost:8000/ws
VITE_OAUTH_CLIENT_ID=your_client_id
```

---

## Security Considerations

### Authentication & Authorization
- OAuth 2.0 for user authentication
- JWT tokens for API authentication
- Role-based access control (RBAC)
- Secure token storage and refresh

### Data Protection
- Encrypted database connections (TLS)
- Encrypted secrets in Kubernetes
- Secure API key storage
- Data encryption at rest

### Network Security
- HTTPS for all external communication
- WebSocket over WSS
- Network policies in Kubernetes
- Firewall rules for worker nodes

### Agent Security
- Sandboxed code execution
- Resource limits for browser instances
- Input validation and sanitization
- Rate limiting per user

---

## Monitoring & Observability

### Metrics
- Request rates and latencies
- Agent processing times
- Queue depths and processing rates
- Resource utilization (CPU, memory)

### Logging
- Structured logging (JSON format)
- Log aggregation via centralized system
- Log levels: DEBUG, INFO, WARNING, ERROR
- Correlation IDs for request tracking

### Tracing
- Distributed tracing for request flows
- Agent execution traces
- Database query traces
- External API call traces

### Alerting
- Failed agent tasks
- High error rates
- Resource exhaustion
- Service downtime

---

## Scalability

### Horizontal Scaling
- FastAPI: Auto-scaling based on CPU/memory
- FastStream Workers: Manual scaling per agent type
- RabbitMQ: Clustering for high availability
- Redis: Sentinel mode for failover

### Vertical Scaling
- Resource limits configured per deployment
- Browser agent workers need more resources
- Database can be scaled vertically

### Performance Optimization
- Result caching in Redis
- Connection pooling for databases
- Message batching in RabbitMQ
- CDN for frontend static assets

---

## Future Enhancements

- Additional DeepAgents (Calendar, File Management, etc.)
- Advanced memory systems (long-term memory)
- Multi-user collaboration features
- Enhanced browser automation capabilities
- Voice interface integration
- Mobile application support

---

## Conclusion

This architecture provides a scalable, maintainable, and extensible foundation for the AI Assistant system. The supervisor pattern with DeepAgents enables specialized task handling while maintaining centralized coordination. The async message-driven architecture ensures high throughput and reliability, while the modern tech stack provides excellent developer experience and production readiness.

