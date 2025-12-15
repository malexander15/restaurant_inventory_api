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

- Ruby 3.2
- Rails 7 (API-only)
- PostgreSQL / SQLite (dev)
- RSpec for testing
- rack-cors for CORS handling

## Core Features

- Product inventory tracking (by weight or unit)
- Recipes composed of products and/or other recipes
- Polymorphic ingredient system
- Recursive inventory depletion
- Stock validation to prevent negative inventory
- Versioned REST API (`/api/v1`)

## Data Model Overview

- **Product**
  - Raw inventory items (e.g. cheese, chicken)
- **Recipe**
  - Menu items or prepped items (Grilled Chicken Breast: Prepped Item or Quesadilla: Which can be composed of many different products or prepped items aka recipes)
- **RecipeIngredient**
  - Polymorphic join model connecting recipes to products or other recipes

  ## API Endpoints

### Products
- `GET /api/v1/products`
- `POST /api/v1/products`
- `GET /api/v1/products/:id`
- `PATCH /api/v1/products/:id`
- `DELETE /api/v1/products/:id`

### Recipes
- `GET /api/v1/recipes`
- `POST /api/v1/recipes`
- `GET /api/v1/recipes/:id`
- `POST /api/v1/recipes/:id/deplete`

### Recipe Ingredients
- `POST /api/v1/recipes/:recipe_id/recipe_ingredients`
- `PATCH /api/v1/recipes/:recipe_id/recipe_ingredients/:id`
- `DELETE /api/v1/recipes/:recipe_id/recipe_ingredients/:id`

## Setup

```bash
git clone git@github.com:yourusername/restaurant_inventory_api.git
cd restaurant_inventory_api
bundle install
rails db:create db:migrate
rails s -p 3000

## Future Improvements

- Authentication and authorization
- Inventory reporting and alerts
- Integration with POS systems
- Frontend interface using Next.js
- Barcode scanning support

