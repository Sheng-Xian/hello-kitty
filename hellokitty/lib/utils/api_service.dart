import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './constants.dart';
import '../model/pet_weight_model.dart';
import '../model/feeding_data.dart';

class ApiService {
  Future<List<PetWeight>?> getPetWeights() async {
    try {
      var url = Uri.parse(ApiConstants.getWeight);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        PetWeightModel model = petWeightModelFromJson(response.body);
        List<PetWeight> data = model.data;
        return data;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<FeedingRecordsData>?> getRecords() async {
    try {
      var url = Uri.parse(ApiConstants.getRecords);
      debugPrint('http: url $url');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        FeedingRecordsModel model = feedingRecordsModelFromJson(response.body);
        List<FeedingRecordsData> data = model.data;
        debugPrint('http: response $response.body');
        return data;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
