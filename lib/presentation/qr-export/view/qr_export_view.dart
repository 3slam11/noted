import 'package:flutter/material.dart';
import 'package:noted/app/di.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/state_renderer/state_flow_handler.dart';
import 'package:noted/presentation/qr-export/viewmodel/qr_export_viewmodel.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrExportView extends StatefulWidget {
  const QrExportView({super.key});

  @override
  State<QrExportView> createState() => _QrExportViewState();
}

class _QrExportViewState extends State<QrExportView> {
  final QrExportViewModel _viewModel = instance<QrExportViewModel>();

  @override
  void initState() {
    _viewModel.start();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: Text(
          t.qrSettings.generate,
          style: TextStyle(
            fontSize: 23,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: StateFlowHandler(
        stream: _viewModel.outputState,
        retryAction: () => _viewModel.start(),
        contentBuilder: (context) => _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          Card(
            elevation: 8,
            shadowColor: Theme.of(
              context,
            ).colorScheme.shadow.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: StreamBuilder<String>(
                stream: _viewModel.outputQrData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: snapshot.data!,
                            version: QrVersions.auto,
                            size: MediaQuery.of(context).size.width * 0.6,
                            backgroundColor: Colors.white,
                            eyeStyle: QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_2,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              t.qrSettings.generated,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  // Loading state
                  return Container(
                    height: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t.qrSettings.generating,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
