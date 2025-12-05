from django.shortcuts import render, get_object_or_404
from django.core.paginator import Paginator
from django.views.generic import TemplateView, ListView, DetailView
from django.views.generic.edit import CreateView
from django.urls import reverse_lazy
from django.contrib import messages
from django.db.models import Q
from .models import Product, Category, ContactMessage
from .forms import ContactForm

class HomeView(TemplateView):
    template_name = 'home.html'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['featured_products'] = Product.objects.filter(
            is_featured=True, 
            stock_quantity__gt=0
        )[:8]
        context['categories'] = Category.objects.all()[:6]
        return context

class ProductListView(ListView):
    model = Product
    template_name = 'products.html'
    context_object_name = 'products'
    paginate_by = 12
    
    def get_queryset(self):
        queryset = Product.objects.filter(stock_quantity__gt=0)
        
        # Filter by category
        category_slug = self.request.GET.get('category')
        if category_slug:
            queryset = queryset.filter(category__slug=category_slug)
        
        # Filter by age group
        age_group = self.request.GET.get('age_group')
        if age_group:
            queryset = queryset.filter(age_group=age_group)
        
        # Filter by price range
        min_price = self.request.GET.get('min_price')
        max_price = self.request.GET.get('max_price')
        if min_price:
            queryset = queryset.filter(price__gte=min_price)
        if max_price:
            queryset = queryset.filter(price__lte=max_price)
        
        # Search functionality
        search_query = self.request.GET.get('search')
        if search_query:
            queryset = queryset.filter(
                Q(name__icontains=search_query) |
                Q(description__icontains=search_query) |
                Q(category__name__icontains=search_query)
            )
        
        # Ordering
        order = self.request.GET.get('order', 'name')
        if order in ['name', 'price', '-price', 'rating', '-created_at']:
            queryset = queryset.order_by(order)
        
        return queryset
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['categories'] = Category.objects.all()
        context['age_groups'] = Product.AGE_GROUPS
        
        # Get the 3 main categories
        main_categories = ['educational-toys', 'creative-arts', 'outdoor-active']
        context['main_categories'] = Category.objects.filter(slug__in=main_categories)[:3]
        
        return context

class ProductDetailView(DetailView):
    model = Product
    template_name = 'toy_detail.html'
    context_object_name = 'product'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # Get related products from same category
        context['related_products'] = Product.objects.filter(
            category=self.object.category
        ).exclude(id=self.object.id)[:4]
        return context

class AboutView(TemplateView):
    template_name = 'about.html'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['stats'] = {
            'years_in_business': 25,
            'products_sold': 1000000,
            'happy_customers': 50000,
            'countries': 15,
        }
        return context

class ContactView(CreateView):
    model = ContactMessage
    form_class = ContactForm
    template_name = 'contact.html'
    success_url = reverse_lazy('contact')
    
    def form_valid(self, form):
        messages.success(self.request, 'Thank you for your message! We will get back to you soon.')
        return super().form_valid(form)

def category_products(request, slug):
    category = get_object_or_404(Category, slug=slug)
    products = Product.objects.filter(category=category, stock_quantity__gt=0)
    return render(request, 'category_products.html', {
        'category': category,
        'products': products
    })