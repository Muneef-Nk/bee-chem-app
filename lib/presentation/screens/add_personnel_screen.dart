import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/role_model.dart';
import '../providers/add_personnel_provider.dart';

class AddPersonnelScreen extends StatefulWidget {
  final int? personnelId; // null = Add, non-null = Edit
  const AddPersonnelScreen({super.key, this.personnelId});

  @override
  State<AddPersonnelScreen> createState() => _AddPersonnelScreenState();
}

class _AddPersonnelScreenState extends State<AddPersonnelScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController suburbController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AddPersonnelProvider>(context, listen: false);

    // Load roles first
    provider.fetchRoles().then((_) async {
      // If editing, load personnel details
      if (widget.personnelId != null) {
        await provider.fetchPersonnelDetails(widget.personnelId!);
        final p = provider.currentPersonnel;

        if (p != null) {
          firstNameController.text = p.firstName ?? '';
          lastNameController.text = p.lastName ?? '';
          contactController.text = p.contactNumber ?? '';
          addressController.text = p.address ?? '';
          suburbController.text = p.suburb ?? '';
          stateController.text = p.state ?? '';
          countryController.text = p.country ?? '';

          // Pre-select role if available
          // if (p.roleId != null) {
          //   final matchedRole = provider.roles.firstWhere(
          //     (r) => r.id == p.roleId,
          //     orElse: () => provider.roles.first,
          //   );
          //   provider.setSelectedRole(matchedRole);
          // }
        }
      }
    });
  }

  Future<void> _savePersonnel(AddPersonnelProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "contact_number": contactController.text,
      "address": addressController.text,
      "suburb": suburbController.text,
      "state": stateController.text,
      "country": countryController.text,
      "role_id": provider.selectedRole?.id.toString(),
    };

    final isEdit = widget.personnelId != null;
    final success = await provider.savePersonnel(body: body, id: widget.personnelId);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(isEdit ? 'Personnel updated' : 'Personnel added')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Something went wrong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPersonnelProvider>(
      builder: (context, provider, _) {
        final isEdit = widget.personnelId != null;

        return Scaffold(
          appBar: AppBar(title: Text(isEdit ? 'Edit Personnel' : 'Add Personnel')),
          body: provider.isLoading && provider.roles.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        const Text(
                          "Select Role",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),

                        // Role Checkboxes
                        ...provider.roles.map((role) {
                          final isSelected = provider.selectedRole?.id == role.id;
                          return CheckboxListTile(
                            title: Text(role.role ?? 'Unknown Role'),
                            value: isSelected,
                            onChanged: (_) {
                              provider.setSelectedRole(role);
                            },
                          );
                        }).toList(),

                        if (provider.selectedRole == null)
                          const Padding(
                            padding: EdgeInsets.only(left: 12, bottom: 8),
                            child: Text(
                              'Please select a role',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),

                        const Divider(height: 24),

                        TextFormField(
                          controller: firstNameController,
                          decoration: const InputDecoration(labelText: 'First Name'),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        TextFormField(
                          controller: lastNameController,
                          decoration: const InputDecoration(labelText: 'Last Name'),
                        ),
                        TextFormField(
                          controller: contactController,
                          decoration: const InputDecoration(labelText: 'Contact Number'),
                        ),
                        TextFormField(
                          controller: addressController,
                          decoration: const InputDecoration(labelText: 'Address'),
                        ),
                        TextFormField(
                          controller: suburbController,
                          decoration: const InputDecoration(labelText: 'Suburb'),
                        ),
                        TextFormField(
                          controller: stateController,
                          decoration: const InputDecoration(labelText: 'State'),
                        ),
                        TextFormField(
                          controller: countryController,
                          decoration: const InputDecoration(labelText: 'Country'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: provider.isLoading ? null : () => _savePersonnel(provider),
                          child: Text(
                            provider.isLoading
                                ? 'Saving...'
                                : isEdit
                                ? 'Update'
                                : 'Add',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
