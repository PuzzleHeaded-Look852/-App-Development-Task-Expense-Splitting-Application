
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String apiKey = 'fca_live_8FLkKp2NJNWTL47MMKIoVtwPaYQRbg3XOXdwLB1y'; // Your API key
  final String baseUrl = 'https://openexchangerates.org/api/'; // Example base URL

  Future<Map<String, dynamic>> fetchExchangeRates(String baseCurrency) async {
    final response = await http.get(Uri.parse('$baseUrl$baseCurrency?app_id=$apiKey'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}