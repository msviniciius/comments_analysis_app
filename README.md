# Comentário Analyzer (Ruby on Rails)

Sistema para importação, tradução, classificação e análise estatística de comentários de usuários, baseado na lista de palavras-chave configurável.

---

## 🧠 Arquitetura e Decisões

- **Ruby on Rails** com sidekiq para jobs assíncronos.
- **HTTParty** para consumo da API [JSONPlaceholder](https://jsonplaceholder.typicode.com).
- **Google Translate API** pública (`https://translate.googleapis.com/translate_a/single`) para tradução automática para PT-BR.
- **State Machine manual**: comentários transitam entre `new`, `processing`, `approved`, `rejected`.
- **Redis Cache** para otimizar reprocessamento e cálculos estatísticos.
- **DescriptiveStatistics** gem para cálculo de: média, mediana, desvio padrão e contagem.
- **Separation of concerns**: uso de `Query Objects`, `Presenters` e `Jobs` para organizar responsabilidades.

---

## 📦 Requisitos

- Ruby `>= 2.7`
- Rails `>= 6`
- Redis
- Sidekiq

---

## ⚙️ Setup

```bash
git clone https://github.com/seu-usuario/nome-do-projeto.git
cd nome-do-projeto

bundle install
yarn install # se usar webpacker

# Setup do banco de dados
rails db:create db:migrate db:seed

# Subir Redis (caso não esteja rodando)
redis-server

# Subir sidekiq
bundle exec sidekiq

# Subir o servidor
rails s
```

---

## 🗃️ Seed inicial (opcional)

O arquivo de seeds cria um conjunto de palavras-chave traduzidas automaticamente do inglês para o português usando a Google Translate API pública.

Para rodar:

```bash
rails db:seed
```

---

## 🔄 Pipeline de Processamento

1. **POST /v1/analyze**
   - Recebe um JSON com `{ "username": "Leanne Graham" }`
   - Busca os posts e comentários do usuário na API JSONPlaceholder
   - Processa cada comentário:
     - Traduz o texto
     - Classifica com base nas palavras-chave
     - Salva o status e atualiza métricas

2. **Machine State dos Comentários**
   - `new` → `processing` → `approved` / `rejected`

3. **Métricas Calculadas**
   - Média (`avg`)
   - Mediana (`median`)
   - Desvio Padrão (`std_dev`)
   - Contagem (`count`)

4. **Atualização automática**
   - Ao criar/editar/excluir uma palavra-chave:
     - Todos os comentários são reprocessados
     - Métricas por usuário e grupo são recalculadas

---

## 📊 Fórmulas Estatísticas

Usando [descriptive_statistics](https://github.com/eliotsykes/descriptive-statistics):

- Média:
  ```ruby
  lengths.mean
  ```

- Mediana:
  ```ruby
  lengths.median
  ```

- Desvio padrão:
  ```ruby
  lengths.standard_deviation
  ```

---

## 📬 Endpoints (para testar via Postman)

### Analisar usuário
`POST /v1/analyze`

**Body:**
```json
{
  "username": "Leanne Graham"
}
```

---

### Progresso de jobs
`GET /v1/progress`

---

### Listar palavras-chave
`GET /keywords`

---

### Listar comentarios importados
`GET /comments`

---

### Criar palavra-chave
`POST /keywords`

Form data:
```bash
name=exemplo
```

---

### Excluir palavra-chave
`DELETE /keywords/:id`

---

## ✅ Testes (se houver)

```bash
bundle exec rspec
```

---

## 🚀 Serviços

- **Redis**: caching e Sidekiq
- **Sidekiq**: jobs assíncronos (`comment import`, `processing`, `metric calculation`)
- **Google Translate API**: tradução sem autenticação

---

## 📂 Diretórios úteis

- `app/jobs/`: processamento assíncrono
- `app/services/`: tradutor e classificador
- `app/queries/`: filtros e buscas
- `app/presenters/`: estrutura de resposta dos endpoints

---

## 💡 Melhorias Futuras

- Persistência da tradução (evitar retradução)
- Indexação para busca rápida
- Web interface com Turbo/Hotwire
- Testes de performance e benchmark do pipeline

---

## 📜 Licença

MIT