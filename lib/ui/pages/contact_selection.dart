import 'package:flutter/material.dart';

class Contact {
  final int id;
  final String name;
  late bool isFavorite;

  Contact({required this.id, required this.name, required this.isFavorite});
}

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
  String activeTab = 'contacts';
  final TextEditingController searchController = TextEditingController();

  final List<Contact> contacts = [
    Contact(id: 1, name: 'Jean Dupont', isFavorite: true),
    Contact(id: 2, name: 'Marie Martin', isFavorite: false),
    Contact(id: 3, name: 'Pierre Durant', isFavorite: true),
    Contact(id: 4, name: 'Sophie Bernard', isFavorite: false),
  ];

  List<Contact> get filteredContacts {
    return contacts.where((contact) {
      bool matchesSearch = contact.name
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
      bool matchesTab = activeTab == 'contacts' ||
          (activeTab == 'favoris' && contact.isFavorite);
      return matchesSearch && matchesTab;
    }).toList();
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

  void toggleFavorite(Contact contact) {
    setState(() {
      contact.isFavorite = !contact.isFavorite;
    });
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
                  ? 'Transfert'
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
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: primaryColor),
                    hintText: 'Rechercher',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: primaryColor.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
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
                child: ListView.builder(
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
                          backgroundColor: primaryColor.withOpacity(0.1),
                          child: Text(
                            contact.name[0],
                            style: const TextStyle(color: primaryColor),
                          ),
                        ),
                        title: Text(
                          contact.name,
                          style: const TextStyle(color: textColor),
                        ),
                        trailing: isSelectionMode
                            ? Checkbox(
                                activeColor: primaryColor,
                                value: selectedContacts.contains(contact.id),
                                onChanged: (bool? value) {
                                  toggleSelection(contact.id);
                                },
                              )
                            : PopupMenuButton<String>(
                                icon:
                                    Icon(Icons.more_vert, color: primaryColor),
                                onSelected: (value) {
                                  if (value == 'favorite') {
                                    toggleFavorite(contact);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'favorite',
                                    child: Text(activeTab == 'favoris'
                                        ? 'Enlever des Favoris'
                                        : 'Ajouter aux Favoris'),
                                  ),
                                ],
                              ),
                        onTap: isSelectionMode
                            ? () => toggleSelection(contact.id)
                            : null,
                      ),
                    );
                  },
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
                  print('Transfert pour ${selectedContacts.length} contact(s)');
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
