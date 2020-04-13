/*
    MIT License

    Copyright (c) 2020 Boris-Wilfried Nyasse
    [ https://gitlab.com/bwnyasse | https://github.com/bwnyasse ]

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_breaking_news/src/app/blocs/blocs.dart';
import 'package:flutter_breaking_news/src/app/models/models.dart';
import 'package:flutter_breaking_news/src/app/providers/providers.dart';
import 'package:flutter_breaking_news/src/app/services/services.dart';
import 'package:flutter_breaking_news/src/app/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../common.dart';

void main() {
  LocalStorageServiceMock localStorageServiceMock;
  AuthServiceMock authServiceMock;
  DataBloc dataBloc;
  AuthBlocMock authBloc;
  ApiService apiService;
  MockClient mockClient;

  setUp(() {
    // Data & Api Service
    localStorageServiceMock = LocalStorageServiceMock();
    when(localStorageServiceMock.getApiKey())
        .thenAnswer((_) => Future.value('fake_key'));
    when(localStorageServiceMock.getCountryFlag())
        .thenAnswer((_) => Future.value('fake_country_flag'));
    mockClient = MockClient((request) async {
      return Response(json.encode(mockJsonResponse), 200);
    });
    apiService = ApiService(mockClient, localStorageServiceMock);
    dataBloc = DataBloc(service: apiService);

    // Auth & AuthBloc
    authServiceMock = AuthServiceMock();
    when(authServiceMock.signInWithGoogle())
        .thenAnswer((_) => Future.value(mockUser));
    authBloc = AuthBlocMock(service: authServiceMock, state: AuthFailedState());
  });

  tearDown(() {
    authBloc?.close();
    dataBloc?.close();
  });

  testWidgets('NewsLatest', (WidgetTester tester) async {
    //TODO: TEST DataLoading & DataLoaded
    LocalStorageServiceMock localStorageServiceMock = LocalStorageServiceMock();
    when(localStorageServiceMock.countries())
        .thenReturn(CountryList.fromJson(mockCountriesAsJson()).countries);
    when(localStorageServiceMock.getData())
        .thenAnswer((_) => Future.value(mockLocalStorageData));

    await tester.pumpWidget(
      MaterialApp(
        home: AppProvider(
            httpClient: mockClient,
            localStorageService: localStorageServiceMock,
            authService: authServiceMock,
            child: BlocProvider(
              create: (context) => dataBloc,
              child: Provider<CurrentUser>(
                  create: (_) => mockUser, child: NewsLatest()),
            )),
      ),
    );
    // Auth Logout Button
    Finder screen = find.byType(NewsLatest);
    expect(screen, findsOneWidget);
  });
}
