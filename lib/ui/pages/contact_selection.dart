import 'package:flutter/material.dart';
import 'package:wave_mobile_flutter/config/database_helper.dart';
import 'package:wave_mobile_flutter/dto/contact_dto_response.dart';

class ContactSelectionPage extends StatefulWidget {
  ContactSelectionPage({super.key});

  @override
  State<ContactSelectionPage> createState() => _ContactSelectionPageState();
}

class _ContactSelectionPageState extends State<ContactSelectionPage> {
  static const primaryColor = Color(0xFF4749D5);
  static const backgroundColor = Color(0xFFF5F6F9);
  static const textColor = Color(0xFF2D3142);

  Set<int> selectedContacts = {};
  bool isSelectionMode = false;
  bool isLoading = true; // Track loading state
  String activeTab = 'contacts';
  final TextEditingController searchController = TextEditingController();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  // Load contacts from SQLite
  Future<void> _loadContacts() async {
    setState(() {
      isLoading = true;
    });
    final dbHelper = DatabaseHelper.instance;
    final contactData = await dbHelper.fetchContacts();
    setState(() {
      contacts = contactData.map((map) => Contact.fromMap(map)).toList();
      isLoading = false; // Loading complete
    });
  }

  void startSelectionMode() {
    setState(() {
      isSelectionMode = true;
    });
  }

  void cancelSelection() {
    setState(() {
      selectedContacts.clear();
      isSelectionMode = false;
    });
  }

  void toggleSelection(int contactId) {
    setState(() {
      if (selectedContacts.contains(contactId)) {
        selectedContacts.remove(contactId);
      } else {
        selectedContacts.add(contactId);
      }
    });
  }

  void toggleFavorite(Contact contact) async {
    setState(() {
      contact.isFavorite = !contact.isFavorite;
    });
    await DatabaseHelper.instance.updateContact(contact.toMap());
  }

  List<Contact> get filteredContacts {
    return contacts.where((contact) {
      bool matchesSearch = contact.nom
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
      bool matchesTab = activeTab == 'contacts' ||
          (activeTab == 'favoris' && contact.isFavorite);
      return matchesSearch && matchesTab;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          children: [
            Text(
              selectedContacts.isEmpty
                  ? 'Contacts'
                  : '${selectedContacts.length} sélectionné(s)',
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            TextButton(
              onPressed: isSelectionMode ? cancelSelection : startSelectionMode,
              child: Text(
                isSelectionMode ? 'Annuler' : 'Sélectionner',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loader while loading
          : Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.search, color: primaryColor),
                          hintText: 'Rechercher',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: primaryColor.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: primaryColor, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Row(
                      children: [
                        _buildTab('Favoris', 'favoris'),
                        _buildTab('Contacts', 'contacts'),
                      ],
                    ),
                    Expanded(
                      child: filteredContacts.isNotEmpty
                          ? ListView.builder(
                              padding: selectedContacts.isNotEmpty
                                  ? const EdgeInsets.only(bottom: 80)
                                  : EdgeInsets.zero,
                              itemCount: filteredContacts.length,
                              itemBuilder: (context, index) {
                                final contact = filteredContacts[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                  child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            primaryColor.withOpacity(0.1),
                                        child: Text(
                                          contact.prenom.isNotEmpty
                                              ? contact.prenom[0]
                                              : 'N', // Fallback to 'N' if contact.nom is empty
                                          style: const TextStyle(
                                              color: primaryColor),
                                        ),
                                      ),
                                      title: Text(
                                        '${contact.prenom} ${contact.nom}',
                                        style:
                                            const TextStyle(color: textColor),
                                      ),
                                      trailing: isSelectionMode
                                          ? Checkbox(
                                              activeColor: primaryColor,
                                              value: selectedContacts
                                                  .contains(contact.id),
                                              onChanged: (bool? value) {
                                                toggleSelection(contact.id);
                                              },
                                            )
                                          : PopupMenuButton<String>(
                                              icon: Icon(Icons.more_vert,
                                                  color: primaryColor),
                                              onSelected: (value) {
                                                if (value == 'favorite') {
                                                  toggleFavorite(contact);
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 'favorite',
                                                  child: Text(activeTab ==
                                                          'favoris'
                                                      ? 'Enlever des Favoris'
                                                      : 'Ajouter aux Favoris'),
                                                ),
                                              ],
                                            ),
                                      onTap: () {
                                        if (isSelectionMode) {
                                          toggleSelection(contact.id);
                                        } else {
                                          Navigator.pushNamed(
                                            context,
                                            '/transfertcontact',
                                            arguments: {
                                              'name':
                                                  '${contact.prenom}${contact.nom}',
                                              'phoneNumber': contact.telephone,
                                            },
                                          );
                                        }
                                      }),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No contacts found.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),
                  ],
                ),
                if (selectedContacts.isNotEmpty)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/transfertmultiple',
                          arguments: {
                            'contacts': contacts
                                .where((contact) =>
                                    selectedContacts.contains(contact.id))
                                .toList()
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Transférer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildTab(String title, String tab) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            activeTab = tab;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: activeTab == tab ? primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: activeTab == tab ? primaryColor : Colors.black54,
              fontWeight:
                  activeTab == tab ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
