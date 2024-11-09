import 'package:contacts_service/contacts_service.dart';
import 'package:wave_mobile_flutter/config/database_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactSyncService {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<void> syncContactsFromDevice() async {
    // Vérifiez et demandez la permission pour accéder aux contacts
    if (await Permission.contacts.request().isGranted) {
      // Récupérez les contacts du répertoire de l'appareil
      Iterable<Contact> deviceContacts = await ContactsService.getContacts();

      // Insérez chaque contact dans la base de données locale SQLite
      for (var contact in deviceContacts) {
        if (contact.phones != null && contact.phones!.isNotEmpty) {
          final contactData = {
            'nom': contact.givenName ?? '',
            'prenom': contact.familyName ?? '',
            'telephone': contact.phones!.first.value ?? '',
            'isFavorite': 0
          };
          await dbHelper.addContact(contactData);
        }
      }
    } else {
      // Si la permission est refusée, affichez un message ou traitez l'erreur
      print("Permission refusée pour accéder aux contacts.");
    }
  }
}