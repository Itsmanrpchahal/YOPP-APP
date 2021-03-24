import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ReportEvent extends Equatable {
  final String reportTo;
  final String title;
  final String subject;
  final String description;

  ReportEvent({
    @required this.reportTo,
    @required this.title,
    @required this.subject,
    @required this.description,
  });

  @override
  List<Object> get props => [reportTo, title, subject, description];
}
