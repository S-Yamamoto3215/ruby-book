# frozen_string_literal: true

def init_term_names
  $term_names = { 'last30' => '過去30日間', 'months-3' => '過去3か月' }
  (2001..Time.now.year).reverse_each do |year|
    $term_names["year-#{year}"] = "#{year}年"
  end
  $term_names['archived'] = '非表示にした注文'
end
init_term_names

if __FILE__ == $PROGRAM_NAME
  p $term_names
end
