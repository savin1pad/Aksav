import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:journey/core/logger.dart';
import 'package:journey/core/models/zettelnote.dart';

class ZettelRepository with LogMixin {
  final String baseUrl = 'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app';

  Future<ZettelNote> createZettel(ZettelNote zettel) async {
    final url = Uri.parse('$baseUrl/Zettels.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(zettel.toJson()),
      );

      if (response.statusCode == 200) {
        return zettel;
      } else {
        throw Exception('Failed to create zettel');
      }
    } catch (e) {
      errorLog('Error creating zettel: $e');
      rethrow;
    }
  }

  Future<List<ZettelNote>> getUserZettels(String userId) async {
    final url = Uri.parse(
      '$baseUrl/Zettels.json?orderBy="userId"&equalTo="$userId"',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        warningLog('checking for length ${data.length} and the decoded response body $data');
        final zettelmodel = data.map((e) => ZettelNote.fromMap(e['id'], e)).toList();
        warningLog('zettelmodels $zettelmodel');
        return zettelmodel;
      } else {
        throw Exception('Failed to load zettels');
      }
    } catch (e) {
      errorLog('Error fetching zettels: $e');
      rethrow;
    }
  }

  Future<void> linkZettels(String zettelId, String linkedZettelId) async {
    final url = Uri.parse('$baseUrl/Zettels/$zettelId/linkedZettelIds.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(linkedZettelId),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to link zettels');
      }
    } catch (e) {
      errorLog('Error linking zettels: $e');
      rethrow;
    }
  }

  Future<void> updateZettel(ZettelNote zettel) async {
    final url = Uri.parse('$baseUrl/Zettels/${zettel.id}.json');
    try {
      final response = await http.patch(
        url,
        body: json.encode(zettel.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update zettel');
      }
    } catch (e) {
      errorLog('Error updating zettel: $e');
      rethrow;
    }
  }

  Future<List<ZettelNote>> searchNotesByTitle(String title)async{
    final url = Uri.parse('$baseUrl/Zettels.json?orderBy="title"&equalTo="$title"');
    try{
      final response =  await http.get(url);
      if(response.statusCode == 200){
        final data = json.decode(response.body) as List;
        final zettelmodels = data.map((e) => ZettelNote.fromMap(e['id'], e)).toList();
        warningLog('zettelmodels $zettelmodels');
        return zettelmodels;
        } else {
          throw Exception('Failed to search notes by title');
        }
      } catch (e) {
        errorLog('Error searching notes by title: $e');
        rethrow;
      }
    }
  }