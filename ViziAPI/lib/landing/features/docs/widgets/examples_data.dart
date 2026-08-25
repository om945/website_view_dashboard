class ExampleDefinition {
  const ExampleDefinition({
    required this.id,
    required this.group,
    required this.label,
    required this.language,
    required this.code,
    this.filename,
  });
  final String id, group, label, language, code;
  final String? filename;
}

const viziApiEndpoint =
    'https://viziapi.onrender.com/api/v1/public/sites/YOUR_SITE_KEY/visitor-count';

const viziApiExamples = <ExampleDefinition>[
  ExampleDefinition(
    id: 'fetch',
    group: 'Browser',
    label: 'Fetch',
    language: 'JavaScript',
    filename: 'visitor-count.js',
    code:
        '''async function getVisitorCount() {
    const response = await fetch('$viziApiEndpoint');
    if (!response.ok) {
        throw new Error('Failed to fetch visitor count');
    }
    const data = await response.json();
    console.log(data.totalVisitors);
    return data;
}''',
  ),
  ExampleDefinition(
    id: 'javascript',
    group: 'Browser',
    label: 'JavaScript',
    language: 'JavaScript',
    code: '''const response = await fetch('$viziApiEndpoint');

if (!response.ok) {
  throw new Error('Unable to fetch visitor count');
}

const { totalVisitors } = await response.json();
document.querySelector('#total-visitors').textContent = totalVisitors;
''',
  ),
  ExampleDefinition(
    id: 'styled-card',
    group: 'Browser',
    label: 'Styled card',
    language: 'HTML / CSS',
    filename: 'visitor-card.html',
    code:
        '''<div class="visitor-card">
  <strong id="total-visitors">—</strong>
  <span>total visitors</span>
</div>
<style>
  .visitor-card {
    padding: 1rem;
    border: 1px solid #ddd;
  }
</style>
<script>
  const response = await fetch('$viziApiEndpoint');
  if (!response.ok) {
    throw new Error('Unable to fetch visitor count');
  }

  const data = await response.json();
  document.querySelector('#total-visitors').textContent = data.totalVisitors;
</script>''',
  ),
  ExampleDefinition(
    id: 'typescript',
    group: 'Browser',
    label: 'TypeScript',
    language: 'TypeScript',
    code:
        '''type VisitorCountResponse = {
  totalVisitors: number;
};
const response = await fetch('$viziApiEndpoint');
if (!response.ok) {
  throw new Error('Unable to fetch visitor count');
}

const data: VisitorCountResponse = await response.json();
console.log(data.totalVisitors);''',
  ),
  ExampleDefinition(
    id: 'react',
    group: 'React',
    label: 'React',
    language: 'TSX',
    code:
        '''import { useEffect, useState } from 'react';

type Counts = {
  totalVisitors: number;
};

export default function VisitorCount() {
  const [counts, setCounts] = useState<Counts | null>(null);

  useEffect(() => {
    fetch('$viziApiEndpoint')
      .then((response) => {
        if (!response.ok) {
          throw new Error('Request failed');
        }
        return response.json();
      })
      .then(setCounts);
  }, []);

  return <span>{counts?.totalVisitors ?? '—'} visitors</span>;
}''',
  ),
  ExampleDefinition(
    id: 'next',
    group: 'React',
    label: 'Next.js',
    language: 'TSX',
    code:
        '''export default async function VisitorCount() {
  const response = await fetch('$viziApiEndpoint', {
    next: { revalidate: 60 },
  });

  if (!response.ok) {
    throw new Error('Request failed');
  }

  const { totalVisitors } = await response.json();
  return <p>{totalVisitors} total</p>;
}''',
  ),
  ExampleDefinition(
    id: 'swr',
    group: 'React',
    label: 'SWR',
    language: 'TSX',
    code:
        '''import useSWR from 'swr';

const fetcher = (url: string) =>
  fetch(url).then((response) => {
    if (!response.ok) {
      throw new Error('Request failed');
    }
    return response.json();
  });

export function VisitorCount() {
  const { data, error } = useSWR('$viziApiEndpoint', fetcher);

  if (error) {
    return <span>Unavailable</span>;
  }

  return <span>{data?.totalVisitors ?? '—'} visitors</span>;
}''',
  ),

  ExampleDefinition(
    id: 'python',
    group: 'Python',
    label: 'requests',
    language: 'Python',
    code:
        '''import requests

response = requests.get('$viziApiEndpoint', timeout=10)
response.raise_for_status()

data = response.json()
print(data["totalVisitors"])''',
  ),
  ExampleDefinition(
    id: 'httpx',
    group: 'Python',
    label: 'httpx',
    language: 'Python',
    code:
        '''import httpx

with httpx.Client(timeout=10) as client:
    response = client.get('$viziApiEndpoint')
    response.raise_for_status()
    data = response.json()

print(data["totalVisitors"])''',
  ),
  ExampleDefinition(
    id: 'fastapi',
    group: 'Python',
    label: 'FastAPI',
    language: 'Python',
    code:
        '''from fastapi import FastAPI, HTTPException
import httpx

app = FastAPI()

@app.get("/visitor-count")
async def visitor_count():
    async with httpx.AsyncClient() as client:
        response = await client.get('$viziApiEndpoint')

    if response.is_error:
        raise HTTPException(response.status_code, "Request failed")

    return response.json()''',
  ),
  ExampleDefinition(
    id: 'php',
    group: 'Server',
    label: 'PHP cURL',
    language: 'PHP',
    code:
        '''<?php
\$curl = curl_init('$viziApiEndpoint');
curl_setopt(\$curl, CURLOPT_RETURNTRANSFER, true);

\$response = curl_exec(\$curl);
if (\$response === false) {
    throw new RuntimeException(curl_error(\$curl));
}

curl_close(\$curl);
\$data = json_decode(\$response, true, flags: JSON_THROW_ON_ERROR);
echo \$data['totalVisitors'];''',
  ),
  ExampleDefinition(
    id: 'go',
    group: 'Server',
    label: 'Go',
    language: 'Go',
    code:
        '''package main

import (
  "encoding/json"
  "fmt"
  "net/http"
)

func main() {
  response, err := http.Get("$viziApiEndpoint")
  if err != nil {
    panic(err)
  }
  defer response.Body.Close()

  if response.StatusCode != http.StatusOK {
    panic("request failed")
  }

  var data struct {
    TotalVisitors  int `json:"totalVisitors"`
  }

  if err := json.NewDecoder(response.Body).Decode(&data); err != nil {
    panic(err)
  }

  fmt.Println(data.TotalVisitors)
}''',
  ),
  ExampleDefinition(
    id: 'java',
    group: 'Server',
    label: 'Java',
    language: 'Java',
    code:
        '''var client = java.net.http.HttpClient.newHttpClient();
var request = java.net.http.HttpRequest.newBuilder()
    .uri(java.net.URI.create("$viziApiEndpoint"))
    .build();

var response = client.send(
    request,
    java.net.http.HttpResponse.BodyHandlers.ofString()
);

if (response.statusCode() != 200) {
    throw new RuntimeException("Request failed");
}

System.out.println(response.body()); // JSON: totalVisitors''',
  ),
  ExampleDefinition(
    id: 'csharp',
    group: 'Server',
    label: 'C#',
    language: 'C#',
    code:
        '''using var client = new HttpClient();
using var response = await client.GetAsync("$viziApiEndpoint");
response.EnsureSuccessStatusCode();

var data = await response.Content.ReadFromJsonAsync<VisitorCount>();
Console.WriteLine(\$"{data?.TotalVisitors} total");

record VisitorCount(int TotalVisitors);''',
  ),
  ExampleDefinition(
    id: 'rust',
    group: 'Server',
    label: 'Rust',
    language: 'Rust',
    code:
        '''#[derive(serde::Deserialize)]
struct VisitorCount {
    total_visitors: u64,
}

#[tokio::main]
async fn main() -> Result<(), reqwest::Error> {
    let data: VisitorCount = reqwest::get("$viziApiEndpoint")
        .await?
        .error_for_status()?
        .json()
        .await?;

    println!("{} total", data.total_visitors);
    Ok(())
}''',
  ),
  ExampleDefinition(
    id: 'dart',
    group: 'Mobile',
    label: 'Dart / Flutter',
    language: 'Dart',
    code:
        '''import 'dart:convert';
import 'package:http/http.dart' as http;

final response = await http.get(
  Uri.parse('$viziApiEndpoint'),
);

if (response.statusCode != 200) {
  throw Exception('Request failed');
}

final data = jsonDecode(response.body) as Map<String, dynamic>;
print(data['totalVisitors']);
''',
  ),
  ExampleDefinition(
    id: 'swift',
    group: 'Mobile',
    label: 'Swift',
    language: 'Swift',
    code:
        '''import Foundation

let url = URL(string: "$viziApiEndpoint")!
let (body, response) = try await URLSession.shared.data(from: url)

guard (response as? HTTPURLResponse)?.statusCode == 200 else {
  throw URLError(.badServerResponse)
}

let data = try JSONDecoder().decode(VisitorCount.self, from: body)
print(data.totalVisitors)

struct VisitorCount: Decodable {
  let totalVisitors: Int
}''',
  ),
  ExampleDefinition(
    id: 'node',
    group: 'Node.js',
    label: 'Node.js',
    language: 'JavaScript',
    code: '''const response = await fetch('$viziApiEndpoint');

if (!response.ok) {
  throw new Error(`HTTP \${response.status}`);
}

const { totalVisitors } = await response.json();
console.log({ totalVisitors });''',
  ),
];
