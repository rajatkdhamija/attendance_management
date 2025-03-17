import 'package:attendance_management/core/common/widgets/gradient_background.dart';
import 'package:attendance_management/core/res/media_res.dart';
import 'package:attendance_management/core/services/injection_container.dart'
    show sl;
import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<AbsencesBloc>();
      if (bloc.state is! AbsencesLoaded && bloc.state is! AbsencesFiltered) {
        bloc.add(LoadAbsencesEvent());
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final absencesBloc = context.read<AbsencesBloc>();
      Future.delayed(Duration(milliseconds: 500), () {
        absencesBloc.add(LoadMoreAbsencesEvent());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? startDate;
    String? endDate;
    String? type;

    return BlocProvider(
      create: (_) => sl<AbsencesBloc>()..add(LoadAbsencesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Absences',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: GradientBackground(
          image: MediaRes.onBoardingBackground,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                BlocBuilder<AbsencesBloc, AbsencesState>(
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: DropdownButtonFormField<String>(
                        value: (state is AbsencesFiltered || state is AbsencesLoaded) ? type : null,
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
                          type = value;
                          context.read<AbsencesBloc>().add(
                            FilterAbsencesEvent(type: value),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                BlocBuilder<AbsencesBloc, AbsencesState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    startDate != null
                                        ? DateTime.parse(startDate!)
                                        : DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null && context.mounted) {
                                startDate = picked.toIso8601String();
                                context.read<AbsencesBloc>().add(
                                  FilterAbsencesEvent(
                                    startDate: picked.toIso8601String(),
                                    endDate: endDate,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              (state is AbsencesFiltered ||
                                          state is AbsencesLoaded) &&
                                      (startDate != null)
                                  ? 'Start: ${DateFormat('dd MMM yyyy').format(DateTime.parse(startDate!))}'
                                  : 'Select Start Date',
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    endDate != null
                                        ? DateTime.parse(endDate!)
                                        : DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null && context.mounted) {
                                endDate = picked.toIso8601String();
                                context.read<AbsencesBloc>().add(
                                  FilterAbsencesEvent(
                                    startDate: startDate,
                                    endDate: picked.toIso8601String(),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              (state is AbsencesFiltered ||
                                          state is AbsencesLoaded) &&
                                      (endDate != null)
                                  ? 'End: ${DateFormat('dd MMM yyyy').format(DateTime.parse(endDate!))}'
                                  : 'Select End Date',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity, // Makes the button take full width
                  child: ElevatedButton(
                    onPressed: () {
                      startDate = null;
                      endDate = null;
                      context.read<AbsencesBloc>().add(LoadAbsencesEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      // Adjust button height
                      backgroundColor: Colors.redAccent,
                      // Optional: Highlight reset button
                      foregroundColor:
                          Colors.white, // Optional: Ensure text contrast
                    ),
                    child: const Text(
                      'Reset Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: BlocConsumer<AbsencesBloc, AbsencesState>(
                    listener: (context, state) {
                      if (state is AbsencesError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to load absences')),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is AbsencesLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is AbsencesError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                                size: 60,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Oops! Something went wrong.',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'We couldn’t fetch the data. Please try again.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<AbsencesBloc>().add(
                                    LoadAbsencesEvent(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Retry',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is AbsencesEmpty) {
                        return Center(
                          child: Text(
                            'No absences found',
                            style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      } else if (state is AbsencesLoaded ||
                          state is AbsencesFiltered) {
                        final absences =
                            state is AbsencesFiltered
                                ? state.absences
                                : (state as AbsencesLoaded).absences;
                        final hasMore =
                            state is AbsencesLoaded ? state.hasMore : false;
                        if (absences.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No results found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    startDate = null;
                                    endDate = null;
                                    context.read<AbsencesBloc>().add(
                                      LoadAbsencesEvent(),
                                    );
                                  },
                                  child: Text('Reset Filters'),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: absences.length + 1,
                          itemBuilder: (context, index) {
                            if (index == absences.length) {
                              return hasMore
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : const SizedBox.shrink();
                            }
                            final absence = absences[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              child: ListTile(
                                contentPadding: EdgeInsets.all(12),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    absence.image ?? '',
                                  ),
                                  radius: 30,
                                ),
                                title: Text(
                                  absence.name ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Text(
                                      'Type: ${absence.type}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Start: ${DateFormat('dd MMM yyyy').format(DateTime.parse(absence.startDate))}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'End: ${DateFormat('dd MMM yyyy').format(DateTime.parse(absence.endDate))}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
