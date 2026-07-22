$urls = @(
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/page2/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/page3/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/page4/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/page5/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/page6/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/page7/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/page8/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/page9/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/page10/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/page11/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n5/page12/"
)

$results = @()

foreach ($url in $urls) {
    Write-Host "Scraping $url"
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    $html = $response.Content

    $rows = $html -split '<tr class="hover:bg-gray-100 cursor-pointer clickable-row transition-colors"'
    
    for ($i = 1; $i -lt $rows.Length; $i++) {
        $row = $rows[$i]
        
        $wordMatch = [regex]::Match($row, '<span class="text-lg font-medium text-gray-900">(.*?)</span>')
        $word = $wordMatch.Groups[1].Value.Trim()
        
        $pronMatch = [regex]::Match($row, '<div class="text-gray-600 mb-1">(.*?)</div>')
        $pronunciation = $pronMatch.Groups[1].Value.Trim()
        
        $meanMatch = [regex]::Match($row, '<td class="px-6 py-4 text-sm text-gray-700">(.*?)</td>')
        $meaningStr = $meanMatch.Groups[1].Value.Trim()
        
        $meanings = @($meaningStr -split ',' | ForEach-Object { $_.Trim() })
        
        if ($word -ne "") {
            $item = @{
                word = $word
                pronunciation = $pronunciation
                meaning = $meanings
            }
            $results += $item
        }
    }
}

$results | ConvertTo-Json -Depth 5 -Compress:$false | Out-File -FilePath "jlpt_n5_vocab.json" -Encoding utf8
Write-Host "Done! Saved to jlpt_n5_vocab.json"
