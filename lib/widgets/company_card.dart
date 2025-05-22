import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/company_model.dart';
import '../models/funding_model.dart';
import '../screens/company_detail_screen.dart';
import 'dart:ui';

class CompanyCard extends StatefulWidget {
  final CompanyModel company;

  const CompanyCard({
    Key? key,
    required this.company,
  }) : super(key: key);

  @override
  State<CompanyCard> createState() => _CompanyCardState();
}

class _CompanyCardState extends State<CompanyCard> {
  int _selectedFeatureIndex = 0;
  bool _isExpanded = false;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _features = [
    {'icon': Icons.handshake, 'label': 'Partnerships'},
    {'icon': Icons.attach_money, 'label': 'Funding'},
    {'icon': Icons.person, 'label': 'CEO'},
    {'icon': Icons.group, 'label': 'Team'},
    {'icon': Icons.location_on, 'label': 'Location'},
    {'icon': Icons.contact_phone, 'label': 'Contact'},
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onFeatureTap(int index) {
    setState(() {
      _selectedFeatureIndex = index;
      _isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.background,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Logo and Name
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      child: Text(
                        widget.company.name.isNotEmpty ? widget.company.name[0] : '?',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.company.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.company.domain,
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Features Grid
              SizedBox(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: List.generate(_features.length, (index) {
                      final feature = _features[index];
                      return GestureDetector(
                        onTap: () => _onFeatureTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedFeatureIndex == index
                                ? colorScheme.primary.withOpacity(0.1)
                                : colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _selectedFeatureIndex == index
                                  ? colorScheme.primary
                                  : colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                feature['icon'] as IconData,
                                size: 18,
                                color: _selectedFeatureIndex == index
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                feature['label'] as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: _selectedFeatureIndex == index
                                      ? colorScheme.primary
                                      : colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              // Feature Content
              if (_isExpanded)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: RawScrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 8,
                    minThumbLength: 50,
                    radius: const Radius.circular(8),
                    thumbColor: colorScheme.primary.withOpacity(0.8),
                    trackColor: colorScheme.primary.withOpacity(0.1),
                    crossAxisMargin: 2,
                    mainAxisMargin: 2,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _features[_selectedFeatureIndex]['label'] as String,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildFeatureContent(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              // Footer with expand button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureContent() {
    switch (_selectedFeatureIndex) {
      case 0: // Partnerships
        return _buildPartnershipsContent();
      case 1: // Funding
        return _buildFundingContent();
      case 2: // CEO
        return _buildCEOContent();
      case 3: // Team
        return _buildTeamContent();
      case 4: // Location
        return _buildLocationContent();
      case 5: // Contact
        return _buildContactContent();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPartnershipsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Strategic Partners',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '• Microsoft Azure\n• AWS\n• Google Cloud',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildFundingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Funding History',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.company.fundingRounds.map((round) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${round.round} - \$${round.amount}M',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Lead Investor: ${round.leadInvestor}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildCEOContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CEO Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Name: ${widget.company.founder}\nExperience: 15+ years in tech\nEducation: Stanford University',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildTeamContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('CTO', 'Dr. Sarah Chen'),
        _buildInfoRow('COO', 'Michael Rodriguez'),
        _buildInfoRow('Head of Product', 'Lisa Wang'),
        _buildInfoRow('Engineering Lead', 'Alex Kumar'),
        _buildInfoRow('Design Lead', 'Emma Wilson'),
      ],
    );
  }

  Widget _buildLocationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Office', widget.company.location),
        _buildInfoRow('Founded', widget.company.yearFounded.toString()),
        _buildInfoRow('HQ', 'San Francisco, CA'),
        _buildInfoRow('Remote', 'Yes'),
      ],
    );
  }

  Widget _buildContactContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Website', widget.company.domain),
        _buildInfoRow('Email', 'contact@${widget.company.domain}'),
        _buildInfoRow('Phone', '+1 (555) 123-4567'),
        _buildInfoRow('LinkedIn', 'linkedin.com/company/${widget.company.domain}'),
        _buildInfoRow('Twitter', '@${widget.company.domain}'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}