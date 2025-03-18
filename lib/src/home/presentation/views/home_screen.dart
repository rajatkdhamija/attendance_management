import 'package:attendance_management/core/common/widgets/gradient_background.dart';
import 'package:attendance_management/core/res/colours.dart';
import 'package:attendance_management/core/res/media_res.dart';
import 'package:attendance_management/core/services/injection_container.dart'
    show sl;
import 'package:attendance_management/core/utils/core_utils.dart';
import 'package:attendance_management/src/home/presentation/bloc/absences_bloc.dart';
import 'package:attendance_management/src/home/presentation/widgets/absence_list.dart'
    show AbsencesList;
import 'package:attendance_management/src/home/presentation/widgets/date_filter_buttons.dart'
    show DateFilterButtons;
import 'package:attendance_management/src/home/presentation/widgets/filter_dropdown.dart';
import 'package:attendance_management/src/home/presentation/widgets/reset_filter_button.dart'
    show ResetFiltersButton;
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
    final absencesBloc = context.read<AbsencesBloc>();

    if (absencesBloc.state is AbsencesLoadingMore)
      return; // Prevent duplicate calls

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      absencesBloc.add(LoadMoreAbsencesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AbsencesBloc>()..add(LoadAbsencesEvent()),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: GradientBackground(
          image: MediaRes.onBoardingBackground,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<AbsencesBloc, AbsencesState>(
                      buildWhen: (previous, current) {
                        return current is AbsencesLoaded ||
                            current is AbsencesFiltered;
                      },
                      builder: (context, state) {
                        if (state is AbsencesLoaded ||
                            state is AbsencesFiltered) {
                          var totalAbsences = 0;
                          if (state is AbsencesLoaded) {
                            totalAbsences = state.totalAbsences.length;
                          } else if (state is AbsencesFiltered) {
                            totalAbsences = state.totalAbsences.length;
                          }
                          return Text(
                            "Total Absences: $totalAbsences",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colours.primaryColour,
                            ),
                          );
                        }
                        return SizedBox.shrink(); // Hide if not loaded
                      },
                    ),
                    BlocBuilder<AbsencesBloc, AbsencesState>(
                      builder: (context, state) {
                        bool isExporting = state is AbsencesExporting;

                        return ElevatedButton(
                          onPressed:
                              isExporting
                                  ? null
                                  : () {
                                    context.read<AbsencesBloc>().add(
                                      ExportingAbsencesEvent(),
                                    );
                                    Future.delayed(Duration.zero, () {
                                      if (context.mounted) {
                                        CoreUtils.exportAbsencesToICal(
                                          context,
                                          () {
                                            context.read<AbsencesBloc>().add(
                                              ExportingAbsencesSuccessEvent(),
                                            );
                                          },
                                          () {
                                            context.read<AbsencesBloc>().add(
                                              ExportingAbsencesErrorEvent(
                                                message:
                                                    'Failed to export to iCal',
                                              ),
                                            );
                                            CoreUtils.showSnackBar(
                                              context,
                                              'Failed to export to iCal',
                                            );
                                          },
                                        );
                                      }
                                    });
                                  },
                          child: Text(
                            isExporting ? 'Exporting...' : 'Export to iCal',
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5),
                FilterDropdown(),
                SizedBox(height: 5),
                DateFilterButtons(),
                SizedBox(height: 5),
                ResetFiltersButton(),
                SizedBox(height: 5),
                Expanded(
                  child: AbsencesList(scrollController: _scrollController),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Absences',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
    );
  }
}
