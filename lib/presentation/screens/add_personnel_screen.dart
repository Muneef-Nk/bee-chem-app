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

  String? _roleError;

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
    final isValid = _formKey.currentState!.validate();
    final isRoleSelected = provider.selectedRoleIds.isNotEmpty;

    setState(() {
      _roleError = isRoleSelected ? null : 'Please select at least one role';
    });

    if (!isValid || !isRoleSelected) return;

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(success ? Icons.check_circle_outline : Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                success
                    ? (widget.personnelId != null
                          ? 'Personnel updated successfully!'
                          : 'Personnel added successfully!')
                    : 'Failed to save personnel data.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );

    if (success) Navigator.pop(context, true);
  }

  Widget buildLabeledTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return TextFieldWidget(
      controller: controller,
      hint: label,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
      isRequired: isRequired,
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
                              buildLabeledTextField('Address', addressController),
                              buildLabeledTextField('Suburb', suburbController),
                              Row(
                                children: [
                                  Expanded(child: buildLabeledTextField('State', stateController)),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: buildLabeledTextField('Post Code', postCodeController),
                                  ),
                                ],
                              ),
                              buildLabeledTextField(
                                'Contact Number',
                                contactController,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 10),
                              const Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
                              ...provider.roles.map((role) {
                                final isSelected = provider.selectedRoleIds.contains(role.id);
                                return CheckboxListTile(
                                  title: Text(role.role ?? ""),
                                  value: isSelected,
                                  onChanged: (_) => setState(() {
                                    provider.toggleRoleSelection(role.id ?? 0);
                                    _roleError = provider.selectedRoleIds.isNotEmpty
                                        ? null
                                        : 'Please select at least one role';
                                  }),
                                  activeColor: Colors.green,
                                );
                              }).toList(),
                              if (_roleError != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                                  child: Text(
                                    _roleError!,
                                    style: const TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ),
                              buildLabeledTextField(
                                'Additional Notes',
                                additionalNotesController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 4,
                                isRequired: false,
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
