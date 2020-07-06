// Create authors
LOAD CSV WITH HEADERS FROM 'file:///authors.csv' AS row
MERGE (author:Author {author_id:row.author_id})
    ON CREATE SET author.author_name = row.author_name, author.cited_by = row.cited_by;

// Create articles
LOAD CSV WITH HEADERS FROM 'file:///articles.csv' AS row
MERGE (article:Article {article_id:row.article_id})
    ON CREATE SET article.title = row.title, article.pub_year = row.pub_year, article.cited_by = row.cited_by;

// Create affiliations
LOAD CSV WITH HEADERS FROM 'file:///affiliations.csv' AS row
MERGE (aff:Affiliation {affiliation_id:row.affiliation_id})
    ON CREATE SET aff.affiliation_name = row.affiliation;

// Create indices
CREATE INDEX author_id FOR (author:Author) ON (author.author_id);
CREATE INDEX article_id FOR (article:Article) ON (article.article_id);
CREATE INDEX affiliation_id FOR (aff:Affiliation) ON (aff.affiliation_id);

// Create relationships between authors and articles
LOAD CSV WITH HEADERS FROM "file:///authored.csv" AS row
MATCH (author:Author {author_id: row.author_id})
MATCH (article:Article {article_id: row.article_id})
MERGE (author)-[:AUTHORED]->(article);

// Create relationships between authors and affiliations
LOAD CSV WITH HEADERS FROM "file:///affiliated_with.csv" AS row
MATCH (author:Author {author_id: row.author_id})
MATCH (aff:Affiliation {affiliation_id: row.affiliation_id})
MERGE (author)-[:AFFILIATED_WITH]->(aff);