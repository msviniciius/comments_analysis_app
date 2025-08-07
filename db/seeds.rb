
puts "Limpando palavras-chave antigas..."
Comment.delete_all
Keyword.delete_all
Metric.delete_all
Post.delete_all
User.delete_all

puts "Criando palavras-chave..."

keywords = %w[
  excelente
  ótimo
  incrível
  maravilhoso
  sensacional
  perfeito
  bom
  satisfatório
  impressionante
  agradável
  ou
  e
]

keywords.each do |word|
  Keyword.create!(name: word)
end

puts "Palavras-chave criadas com sucesso (#{Keyword.count})"
