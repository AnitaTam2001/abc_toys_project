from django.contrib import admin
from .models import Category, Product, ContactMessage

class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'price', 'age_group', 'stock_quantity', 'is_featured')
    list_filter = ('category', 'age_group', 'is_featured')
    search_fields = ('name', 'description')
    list_editable = ('price', 'stock_quantity', 'is_featured')
    ordering = ('-created_at',)

class ContactMessageAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'subject', 'status', 'created_at')
    list_filter = ('status', 'created_at')
    search_fields = ('name', 'email', 'subject')
    readonly_fields = ('name', 'email', 'subject', 'message', 'created_at')
    
    def has_add_permission(self, request):
        return False

admin.site.register(Category)
admin.site.register(Product, ProductAdmin)
admin.site.register(ContactMessage, ContactMessageAdmin)