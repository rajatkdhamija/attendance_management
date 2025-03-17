import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;

class FilterDropdown extends StatelessWidget {
  const FilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AbsencesBloc, AbsencesState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: DropdownButtonFormField<String>(
            value: null,
            decoration: InputDecoration(
              labelText: 'Filter by Type',
              border: InputBorder.none,
            ),
            items:
                ['All', 'Sickness', 'Vacation', 'Other']
                    .map(
                      (type) => DropdownMenuItem(
                        value: type == 'All' ? null : type,
                        child: Text(type),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              context.read<AbsencesBloc>().add(
                FilterAbsencesEvent(type: value),
              );
            },
          ),
        );
      },
    );
  }
}
