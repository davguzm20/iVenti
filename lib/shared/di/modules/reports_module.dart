import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/features/reports/repositories/ReportRepository.dart';
import 'package:iventi/features/reports/services/ReportService.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';

class ReportsModule {
  static late final ReportRepository reportRepository;
  static late final ReportService reportService;
  static late final ReportController reportController;

  static void register(PostgresDatasource datasource) {
    reportRepository = ReportRepository(datasource);
    reportService = ReportService(reportRepository);
    reportController = ReportController(reportService);
  }
}
