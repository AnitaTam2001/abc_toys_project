#!/bin/bash

echo "Fixing home.html template..."

# Backup the original file
cp templates/home.html templates/home.html.backup 2>/dev/null || true

# Create the corrected home.html
cat > templates/home.html << 'EOF'
{% extends 'base.html' %}

{% block title %}ABC Toys - Home{% endblock %}

{% block content %}
<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6">
                <h1 class="display-4 fw-bold">Spark Imagination, Fuel Learning</h1>
                <p class="lead">Discover our collection of educational and fun toys for children of all ages. Safety certified and designed to inspire creativity.</p>
                <a href="{% url 'products' %}" class="btn btn-light btn-lg">
                    <i class="fas fa-shopping-cart"></i> Shop Now
                </a>
            </div>
            <div class="col-md-6">
                <img src="https://via.placeholder.com/500x300/4a90e2/ffffff?text=Toy+Showcase"
                     alt="Toy Collection" class="img-fluid rounded shadow">
            </div>
        </div>
    </div>
</section>

<!-- Features -->
<section class="py-5">
    <div class="container">
        <div class="row text-center mb-5">
            <div class="col">
                <h2>Why Choose ABC Toys?</h2>
                <p class="text-muted">We're committed to quality, safety, and fun</p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3 mb-4 text-center">
                <div class="feature-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h4>Safety First</h4>
                <p>All toys meet international safety standards</p>
            </div>
            <div class="col-md-3 mb-4 text-center">
                <div class="feature-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <h4>Educational</h4>
                <p>Designed to promote learning and development</p>
            </div>
            <div class="col-md-3 mb-4 text-center">
                <div class="feature-icon">
                    <i class="fas fa-leaf"></i>
                </div>
                <h4>Eco-Friendly</h4>
                <p>Sustainable materials and packaging</p>
            </div>
            <div class="col-md-3 mb-4 text-center">
                <div class="feature-icon">
                    <i class="fas fa-award"></i>
                </div>
                <h4>Quality Guaranteed</h4>
                <p>2-year warranty on all products</p>
            </div>
        </div>
    </div>
</section>

<!-- Featured Products -->
<section class="py-5 bg-light">
    <div class="container">
        <div class="row mb-4">
            <div class="col">
                <h2>Featured Toys</h2>
                <p class="text-muted">Our customer favorites</p>
            </div>
            <div class="col-auto">
                <a href="{% url 'products' %}" class="btn btn-outline-primary">View All</a>
            </div>
        </div>
        
        <div class="row">
            {% for product in featured_products %}
            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                <div class="product-card p-3 rounded">
                    <div class="position-relative mb-3">
                        <img src="https://via.placeholder.com/300x200/4a90e2/ffffff?text={{ product.name|truncatechars:20 }}"
                             class="img-fluid rounded" alt="{{ product.name }}">
                        {% if product.is_featured %}
                        <span class="position-absolute top-0 start-0 badge bg-warning">Featured</span>
                        {% endif %}
                    </div>
                    <h5 class="mb-2">{{ product.name }}</h5>
                    <p class="text-muted small mb-2">{{ product.description|truncatechars:60 }}</p>
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="age-badge">{{ product.get_age_group_display }}</span>
                        <span class="product-price">${{ product.price }}</span>
                    </div>
                    <div class="d-grid">
                        <a href="{% url 'product_detail' product.id %}" class="btn btn-outline-primary btn-sm">
                            <i class="fas fa-eye"></i> View Details
                        </a>
                    </div>
                </div>
            </div>
            {% empty %}
            <div class="col-12">
                <div class="alert alert-info">No featured products available at the moment.</div>
            </div>
            {% endfor %}
        </div>
    </div>
</section>

<!-- Categories -->
<section class="py-5">
    <div class="container">
        <div class="row mb-4">
            <div class="col">
                <h2>Shop By Category</h2>
                <p class="text-muted">Find perfect toys for every interest</p>
            </div>
        </div>
        
        <div class="row">
            <!-- Fixed: Hardcoded categories with correct slugs -->
            <div class="col-md-4 mb-4">
                <div class="category-card p-4 text-center rounded">
                    <div class="mb-3">
                        <i class="fas fa-graduation-cap fa-3x text-primary"></i>
                    </div>
                    <h5>Educational Toys</h5>
                    <a href="{% url 'category_products' 'educational-toys' %}" class="stretched-link"></a>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="category-card p-4 text-center rounded">
                    <div class="mb-3">
                        <i class="fas fa-paint-brush fa-3x text-warning"></i>
                    </div>
                    <h5>Creative Arts</h5>
                    <a href="{% url 'category_products' 'creative-arts' %}" class="stretched-link"></a>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="category-card p-4 text-center rounded">
                    <div class="mb-3">
                        <i class="fas fa-bicycle fa-3x text-success"></i>
                    </div>
                    <h5>Outdoor Active</h5>
                    <a href="{% url 'category_products' 'outdoor-active' %}" class="stretched-link"></a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Call to Action -->
<section class="py-5 bg-primary text-white">
    <div class="container text-center">
        <h2 class="mb-4">Ready to Bring Joy to Your Child?</h2>
        <p class="lead mb-4">Join thousands of happy parents who trust ABC Toys for quality playtime.</p>
        <a href="{% url 'products' %}" class="btn btn-light btn-lg me-2">
            <i class="fas fa-shopping-cart"></i> Start Shopping
        </a>
        <a href="{% url 'contact' %}" class="btn btn-outline-light btn-lg">
            <i class="fas fa-question-circle"></i> Ask Questions
        </a>
    </div>
</section>

<style>
    .category-card {
        transition: transform 0.3s;
        border: none;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    
    .category-card:hover {
        transform: translateY(-10px);
    }
</style>
{% endblock %}
EOF

echo "Home template fixed successfully!"