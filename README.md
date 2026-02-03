# Restaurant Inventory API

A Rails 7 API for managing restaurant inventory using products, recipes, and recursive inventory depletion.

# Project Overview

This project is an internal inventory management API designed for restaurant use.

It models:
- Raw ingredients (products)
- Prepped items (recipes made from products)
- Menu items (recipes made from products and/or other recipes)

Inventory is automatically depleted based on recipes sold, including nested prepped items.

## Tech Stack

- Ruby 3.2.4
- Rails 7 (API-only)
- SQLite3
- RSpec for testing
- JWT + bcrypt for authentication
- rack-cors for CORS handling
- dotenv-rails for local env config

## Core Features

- Product inventory tracking (by weight or unit)
- Recipes composed of products and/or other recipes
- Polymorphic ingredient system
- Recursive inventory depletion with stock validation
- Restaurant-scoped multi-tenant data
- JWT authentication with password reset flow
- Inventory replenishment endpoint
- Barcode-based product lookup
- Versioned REST API (`/api/v1`)

## Data Model Overview

- **Restaurant**
  - Authenticated tenant owning products and recipes
- **Product**
  - Raw inventory items (e.g. cheese, chicken)
- **Recipe**
  - Menu items or prepped items (e.g., Grilled Chicken Breast or Quesadilla)
- **RecipeIngredient**
  - Polymorphic join model connecting recipes to products or other recipes

## API Endpoints

All routes below are under `/api/v1`.

### Auth
- `POST /signup`
- `POST /login`

### Password Reset
- `POST /password/forgot`
- `POST /password/reset`

### Restaurant Profile
- `GET /me`
- `PATCH /me`

### Products
- `GET /products`
- `POST /products`
- `GET /products/:id`
- `PATCH /products/:id`
- `DELETE /products/:id`
- `POST /products/:id/replenish`
- `GET /products/by-barcode/:barcode`

### Recipes
- `GET /recipes`
- `POST /recipes`
- `GET /recipes/:id`
- `PATCH /recipes/:id`
- `DELETE /recipes/:id`
- `POST /recipes/:id/deplete`

Query params:
- `recipe_type=menu_item|prepped_item`
- `simple=true` (returns lightweight payload of `id` and `name`)

### Recipe Ingredients
- `POST /recipes/:recipe_id/recipe_ingredients`
- `PATCH /recipes/:recipe_id/recipe_ingredients/:id`
- `DELETE /recipes/:recipe_id/recipe_ingredients/:id`

## Auth Notes

All endpoints except `/signup`, `/login`, and the password reset routes require:

```
Authorization: Bearer <token>
```

## Setup

```bash
git clone git@github.com:yourusername/restaurant_inventory_api.git
cd restaurant_inventory_api
bundle install
cp .env.example .env
rails db:create db:migrate
rails s -p 3000
```

`FRONTEND_URL` in `.env` is used to build password reset links.

## Tests

```bash
bundle exec rspec
```

## Implemented Since Initial Draft

- Authentication and authorization (JWT)
- Password reset flow
- Restaurant profile endpoints
- Barcode-based product lookup
- Inventory replenishment endpoint

## Future Improvements

- Inventory reporting and alerts
