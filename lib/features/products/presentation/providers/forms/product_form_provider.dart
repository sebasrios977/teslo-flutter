

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import '../../../../shared/shared.dart';
import '../providers.dart';


final productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  
  // final createUpdateCallback = ref.watch(productsRepositoryProvider).createUpdateProduct;
  final createUpdateCallback = ref.watch(productsProvider.notifier).createOrUpdateProduct;
   
  return ProductFormNotifier(
    product: product,
    onSubmitCallback: createUpdateCallback,
  );
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product,
  }): super(ProductFormState(
    id: product.id,
    title: Title.dirty(product.title),
    price: Price.dirty(product.price),
    slug: Slug.dirty(product.slug),
    inStock: Stock.dirty(product.stock),
    sizes: product.sizes,
    gender: product.gender,
    description: product.description,
    tags: product.tags.join(', '),
    images: product.images,
  ));

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    final productLike = {
      'id': state.id == 'new' ? null : state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images.map(
        (image) => image.replaceAll('${Environment.apiUrl}/files/product/', '')
      ).toList(),
    };

    try {
      return await onSubmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Price.dirty(state.price.value),
        Slug.dirty(state.slug.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onTitleChanged(String value) {
    state = state.copyWith(
      title: Title.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(value),
        Price.dirty(state.price.value),
        Slug.dirty(state.slug.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
      price: Price.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Price.dirty(value),
        Slug.dirty(state.slug.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }
  
  void onSlugChanged(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Price.dirty(state.price.value),
        Slug.dirty(value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onStockChanged(int value) {
    state = state.copyWith(
      inStock: Stock.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Price.dirty(state.price.value),
        Slug.dirty(state.slug.value),
        Stock.dirty(value),
      ]),
    );
  }


  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(
      sizes: sizes,
    );
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(
      gender: gender,
    );
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(
      description: description,
    );
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(
      tags: tags,
    );
  }

  void updateProductImage(String path) {
    state = state.copyWith(
      images: [...state.images, path],
    );
  }
}


class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Price price;
  final Slug slug;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false, 
    this.id, 
    this.title = const Title.dirty(''), 
    this.price = const Price.dirty(0),
    this.slug = const Slug.dirty(''), 
    this.sizes = const [], 
    this.gender = 'men', 
    this.inStock = const Stock.dirty(0), 
    this.description = '', 
    this.tags = '', 
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Price? price,
    Slug? slug,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) => ProductFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    price: price ?? this.price,
    slug: slug ?? this.slug,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    inStock: inStock ?? this.inStock,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images,
  );

}