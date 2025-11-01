import 'dart:async';
import 'package:beechem_app/presentation/widgets/header_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/personnel_provider.dart';
import 'add_personnel_screen.dart';
import '../widgets/text_field_widget.dart';

class PersonnelListScreen extends StatefulWidget {
  const PersonnelListScreen({super.key});

  @override
  State<PersonnelListScreen> createState() => _PersonnelListScreenState();
}

class _PersonnelListScreenState extends State<PersonnelListScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PersonnelProvider>(context, listen: false).getPersonnel();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      Provider.of<PersonnelProvider>(context, listen: false).search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PersonnelProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 247, 247),
      body: Column(
        children: [
          buildHeader('Personnel Details List'),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    controller: searchController,
                    hint: 'Search...',
                    textInputAction: TextInputAction.search,
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<PersonnelProvider>(
                      context,
                      listen: false,
                    ).search(searchController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(18),
                    elevation: 4,
                  ),
                  child: const Text(
                    'GO',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: Colors.amber,
              onRefresh: () async {
                searchController.clear();
                await provider.getPersonnel();
              },
              child: _buildBody(provider),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        shape: const StadiumBorder(),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPersonnelScreen()));
        },
        child: const Icon(Icons.add, color: Colors.black, size: 40),
      ),
    );
  }

  Widget _buildBody(PersonnelProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.amber));
    }

    if (provider.errorMessage != null) {
      return Center(child: Text(provider.errorMessage!));
    }

    if (provider.filteredList.isEmpty) {
      return const Center(child: Text('No personnel found'));
    }

    return ListView.builder(
      itemCount: provider.filteredList.length,
      itemBuilder: (context, index) {
        final p = provider.filteredList[index];
        final bool isActive = p.status == '1';
        final String roles = p.roleDetails != null
            ? p.roleDetails!.map((r) => r.role).join(', ')
            : 'No Role';

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddPersonnelScreen(personnelId: p.id)),
                  );
                },
                leading: const CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.people, color: Colors.black),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${p.firstName ?? ''} ${p.lastName ?? ''}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.shade700.withOpacity(0.1)
                            : Colors.red.shade700.withOpacity(0.1),
                        border: Border.all(
                          color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        isActive ? '• Active' : '• Inactive',
                        style: TextStyle(
                          color: isActive ? Colors.green.shade800 : Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          p.contactNumber ?? 'N/A',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            roles,
                            style: const TextStyle(color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade300),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.black),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${p.address ?? ''}, ${p.suburb ?? ''}, ${p.state ?? ''}, ${p.country ?? ''}',
                        style: const TextStyle(color: Color(0xFF5E5E5E)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
