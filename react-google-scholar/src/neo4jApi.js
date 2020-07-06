var _ = require('lodash');

var neo4j = require('neo4j-driver').v1;
var driver = neo4j.driver('bolt://localhost', neo4j.auth.basic('neo4j', 'cs411'));

function getGraph() {
    var session = driver.session();
    return session.run(
        'MATCH (author:Author)-[:AUTHORED]->(article:Article) \
        RETURN author.author_name AS name, collect(article.title) AS title \
        LIMIT 10')
        .then(results => {
            session.close();
            var nodes = [], rels = [], i = 0;
            results.records.forEach(res => {
                nodes.push({title: res.get('name'), label: 'author'});
                var target = i;
                i++;
  
                res.get('title').forEach(name => {
                    var article = {title: name, label: 'article'};
                    var source = _.findIndex(nodes, article);
                    if (source == -1) {
                        nodes.push(article);
                        source = i;
                        i++;
                    }
                    rels.push({source, target})
                })
            });
  
            return {nodes, links: rels};
        }
    );
}

exports.getGraph = getGraph;