import 'package:beechem_app/presentation/widgets/header_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/add_personnel_provider.dart';
import '../widgets/text_field_widget.dart';

class AddPersonnelScreen extends StatefulWidget {
  final int? personnelId;
  const AddPersonnelScreen({super.key, this.personnelId});

  @override
  State<AddPersonnelScreen> createState() => _AddPersonnelScreenState();
}

class _AddPersonnelScreenState extends State<AddPersonnelScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController suburbController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postCodeController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController additionalNotesController = TextEditingController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<AddPersonnelProvider>(context, listen: false);

      await provider.fetchRoles();

      if (widget.personnelId != null) {
        await provider.fetchPersonnelDetails(widget.personnelId!);
        final p = provider.currentPersonnel;
        if (p != null) {
          fullNameController.text = p.firstName ?? '';
          addressController.text = p.address ?? '';
          suburbController.text = p.suburb ?? '';
          stateController.text = p.state ?? '';
          postCodeController.text = p.postcode ?? '';
          contactController.text = p.contactNumber ?? '';
          additionalNotesController.text = p.additionalNotes ?? '';
        }
      }
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    suburbController.dispose();
    stateController.dispose();
    postCodeController.dispose();
    contactController.dispose();
    additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _savePersonnel(AddPersonnelProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    if (provider.selectedRoleIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one role.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final body = {
      "first_name": fullNameController.text,
      "address": addressController.text,
      "suburb": suburbController.text,
      "state": stateController.text,
      "postcode": postCodeController.text,
      "contact_number": contactController.text,
      "role_ids": provider.selectedRoleIds.join(','),
      "additional_notes": additionalNotesController.text,
      "status": provider.isActive ? '1' : '0',
    };

    final success = await provider.savePersonnel(body: body, id: widget.personnelId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.personnelId != null
                ? 'Personnel updated successfully!'
                : 'Personnel added successfully!',
          ),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save personnel data.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildLabeledTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFieldWidget(
          controller: controller,
          hint: 'Please type',
          keyboardType: keyboardType,
          maxLines: maxLines,
          textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPersonnelProvider>(
      builder: (context, provider, _) {
        final isEdit = widget.personnelId != null;

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 241, 245, 248),

          body: provider.isFetching
              ? const Center(child: CircularProgressIndicator(color: Colors.amber))
              : Column(
                  children: [
                    buildHeader('Personnel Details'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              buildLabeledTextField('Full Name', fullNameController),
                              const SizedBox(height: 8),
                              buildLabeledTextField('Address', addressController),
                              const SizedBox(height: 8),
                              buildLabeledTextField('Suburb', suburbController),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(child: buildLabeledTextField('State', stateController)),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: buildLabeledTextField('Post Code', postCodeController),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              buildLabeledTextField(
                                'Contact Number',
                                contactController,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 10),
                              const Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              ...provider.roles.map((role) {
                                final isSelected = provider.selectedRoleIds.contains(role.id);
                                return CheckboxListTile(
                                  title: Text(role.role ?? ""),
                                  value: isSelected,
                                  onChanged: (_) => provider.toggleRoleSelection(role.id ?? 0),
                                  activeColor: Colors.green,
                                );
                              }),

                              const SizedBox(height: 10),

                              buildLabeledTextField(
                                'Additional Notes',
                                additionalNotesController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 4,
                              ),
                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: SwitchListTile(
                                  title: const Text(
                                    'Status',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  value: provider.isActive,
                                  onChanged: provider.setActive,
                                  activeColor: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(double.infinity, 50),
                                        backgroundColor: const Color.fromARGB(255, 199, 198, 198),
                                      ),
                                      child: const Text(
                                        'CANCEL',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: provider.isSaving
                                          ? null
                                          : () => _savePersonnel(provider),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(double.infinity, 50),
                                        backgroundColor: Colors.amber,
                                      ),
                                      child: Text(
                                        provider.isSaving
                                            ? 'Saving...'
                                            : isEdit
                                            ? 'UPDATE'
                                            : 'ADD',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
