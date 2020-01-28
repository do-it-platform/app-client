import 'package:doit_app_client/loading_widget.dart';
import 'package:doit_app_client/search_api_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobCard extends StatefulWidget {
  final String jobId;

  const JobCard({Key key, this.jobId}) : super(key: key);

  @override
  State<JobCard> createState() => JobCardState(jobId: jobId);
}

class JobCardState extends State<JobCard> {
  final String jobId;
  final SearchApiClient searchApiClient = SearchApiClient();

  JobCardState({@required this.jobId});

  @override
  Widget build(BuildContext context) {
    return dataLoadingWidget<JobDetails>(
        dataLoadingFn: searchApiClient.findById(jobId),
        widgetBuildFn: (jobDetails) {
          var createdAt = DateTime.fromMillisecondsSinceEpoch(
              int.parse(jobDetails.createdAt));
          var formatedDate = DateFormat.yMd().format(createdAt);
          return Container(
              child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Wrap(
              children: <Widget>[
                Text(jobDetails.title,
                    style: Theme.of(context).textTheme.title),
                Divider(),
                Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[Text(formatedDate)])),
                Text(jobDetails.description,
                    style: Theme.of(context).textTheme.subhead),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      textTheme: ButtonTextTheme.normal,
                      child: Text(jobDetails.payment + '\$ per hour'),
                      onPressed: null,
                    ),
                    FlatButton(
                      child: const Text('APPLY'),
                      onPressed: () {/* ... */},
                    ),
                  ],
                ),
              ],
            ),
          ));
        });
  }
}
