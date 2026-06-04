import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogbookListScreen extends ConsumerStatefulWidget  {

  static const name = 'logbook-list-screen';
  final dynamic filtersLogbook;

  const LogbookListScreen({super.key, this.filtersLogbook});

  @override
  ConsumerState<LogbookListScreen> createState() => _LogbookListScreenState();
}

class _LogbookListScreenState extends ConsumerState<LogbookListScreen> {
  String searchText = '';

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    ref.read(getHistoryLogbooks.notifier).load(
      filters:{
        "page": 1,
        "rows": 20,
        if (widget.filtersLogbook != null)
          "employees-intern": widget.filtersLogbook['employees-intern'],
      }
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final historyLogbooks = ref.watch(getHistoryLogbooks);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderOptionsProfile(headerTxt: 'Bitácoras recientes',),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchBarWidget(
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 30,),
              Expanded(
                child: LogbooksList(
                  items: historyLogbooks,
                  onFilterDate: (range, page, append) async {
                    DateTime? endDate;

                    if (range != null) {
                      endDate = DateTime(
                        range.end.year,
                        range.end.month,
                        range.end.day,
                        23,
                        59,
                        59,
                      );
                    }
                    print(page);
                    await ref.read(getHistoryLogbooks.notifier).load(
                      filters: {
                        "page": page,
                        "rows": 20,

                        if (range != null)
                          "start_date": range.start.toIso8601String(),

                        if (endDate != null)
                          "end_date": formatDateToApi(endDate),
                      },

                      append: append,
                    );
                  },
                ),
              ),
            ],
          )
        ),
      ),
    );
  }


  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 750), () async {
      if (!mounted) return;

      setState(() {
        searchText = value;
      });

      await ref.read(getHistoryLogbooks.notifier).load(
        filters: {
          "first": 1,
          "rows": 20,
          "search": value,
        },
      );
    });
  }
}