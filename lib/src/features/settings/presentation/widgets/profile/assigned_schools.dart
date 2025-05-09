import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otoscopia/src/core/core.dart';

class AssignedSchools extends ConsumerStatefulWidget {
  const AssignedSchools({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AssignedSchoolsState();
}

class _AssignedSchoolsState extends ConsumerState<AssignedSchools> {
  List<SchoolEntity> selectedSchools = [];
  List<SchoolEntity> schools = [];

  bool enableEditing = false;

  @override
  void initState() {
    super.initState();
    schools =
        ref
            .read(schoolsProvider)
            .map(
              (school) => SchoolEntity(
                id: school.id,
                name: school.name,
                abbr: school.abbr,
                code: school.code,
                address: school.address.split("Iligan City")[0],
                isActive: school.isActive,
              ),
            )
            .toList();

    final assignment = ref.read(assignmentsProvider);
    final user = ref.read(userProvider)!;

    selectedSchools =
        assignment
            .where((assignment) => assignment.nurse == user.uid)
            .map(
              (assignment) => schools.firstWhere(
                (school) => school.id == assignment.school,
              ),
            )
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return ListTile.selectable(
              selectionMode: ListTileSelectionMode.multiple,
              title: CustomText(schools[index].name),
              selected: selectedSchools.contains(schools[index]),
            );
          },
          itemCount: schools.length,
        ),
      ),
    );
  }

  void saveInformation() {}

  void editInformation() {
    setState(() {
      enableEditing = !enableEditing;
    });
  }
}
