 import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:qwizap_mobile/src/qwizap/data/models/question_category.dart';

import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../core/params/categories_params.dart';

abstract class CategoriesRemoteDataSource {
  Future<CategoriesOperationResult> fetch(CategoriesFetchParams param);
  Future<bool> create(CategoriesCreateParams param);
  Future<bool> update(CategoriesUpdateParams param);
  Future<bool> delete(CategoriesDeleteParams param);
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final apiService = ApiService();
  
  @override
  Future<CategoriesOperationResult> fetch(CategoriesFetchParams param) async {
    String content = await rootBundle.loadString('assets/data.json');
    final data = jsonDecode(content);

    final list = (data['categories'] as List)
        .map((e) => QuestionCategory.fromJson(e))
        .toList();

    return CategoriesOperationResult.success(
      data: list,
    );
  }

  @override
  Future<bool> create(CategoriesCreateParams param) async {
    final response = await apiService.post(
      ApiEndpoints.createCategories,
      data: {},
    );

    if(response.statusCode != 200){
      throw ApiException.fromResponse(
        statusCode: response.statusCode,
      );
    }

    return true;
  }

  @override
  Future<bool> update(CategoriesUpdateParams param) async {
    final response = await apiService.post(
      ApiEndpoints.updateCategories,
      data: {},
    );

    if(response.statusCode != 200){
      throw ApiException.fromResponse(
        statusCode: response.statusCode,
      );
    }

    return true;
  }

  @override
  Future<bool> delete(CategoriesDeleteParams param) async {
    final response = await apiService.post(
      ApiEndpoints.deleteCategories,
      data: {},
    );

    if(response.statusCode != 200){
      throw ApiException.fromResponse(
        statusCode: response.statusCode,
      );
    }

    return true;
  }
}

