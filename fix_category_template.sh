#!/bin/bash

echo "Creating clean category_products.html template..."

# Remove old template if exists
rm -f templates/category_products.html

# Create clean template
cat > templates/category_products.html << 'EOF'
{% extends 'base.html' %}

{% block title %}ABC Toys - {{ category.name }}{% endblock %}

{% block content %}
<div class="container py-5">
    <!-- Category Header -->
    <div class="row mb-5">
        <div class="col-12 text-center">
            <h1 class="display-4 fw-bold">{{ category.name }}</h1>
            <p class="lead text-muted">{{ category.description }}</p>
            <div class="mt-4">
                <i class="{{ category.icon }} fa-4x text-primary"></i>
            </div>
        </div>
    </div>

    <!-- Products Count -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <h2>{{ products|length }} Products</h2>
                <a href="{% url 'products' %}" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i>View All Products
                </a>
            </div>
        </div>
    </div>

    <!-- Products Grid -->
    {% if products %}
    <div class="row">
        {% for product in products %}
        <div class="col-lg-4 col-md-6 mb-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body">
                    <div class="mb-3">
                        <span class="badge bg-primary">{{ product.category.name }}</span>
                        <span class="badge bg-secondary ms-2">{{ product.get_age_group_display }}</span>
                    </div>
                    <h5 class="card-title">{{ product.name }}</h5>
                    <p class="card-text text-muted">{{ product.description|truncatechars:100 }}</p>
                    
                    <!-- Rating -->
                    {% if product.rating > 0 %}
                    <div class="mb-3">
                        <span class="text-warning">
                            {% for i in "12345" %}
                                {% if forloop.counter <= product.rating %}
                                <i class="fas fa-star"></i>
                                {% else %}
                                <i class="far fa-star"></i>
                                {% endif %}
                            {% endfor %}
                        </span>
                        <span class="text-muted ms-2">({{ product.rating|floatformat:1 }})</span>
                    </div>
                    {% endif %}
                    
                    <div class="d-flex justify-content-between align-items-center">
                        <h4 class="text-primary mb-0">${{ product.price }}</h4>
                        <a href="{% url 'product_detail' product.id %}" class="btn btn-primary">
                            View Details
                        </a>
                    </div>
                </div>
            </div>
        </div>
        {% endfor %}
    </div>
    {% else %}
    <div class="text-center py-5">
        <div class="alert alert-info">
            <i class="fas fa-info-circle me-2"></i>
            No products found in this category yet.
        </div>
        <a href="{% url 'products' %}" class="btn btn-primary mt-3">
            <i class="fas fa-shopping-cart me-2"></i>Browse All Products
        </a>
    </div>
    {% endif %}
</div>
{% endblock %}
EOF

echo "Template created successfully!"
echo "Now restart your server with: python manage.py runserver"