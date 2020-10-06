mvn archetype:generate \
-DgroupId=net.oboki.kakaobank \
-DartifactId=codingtest-p4 \
-Dpackage=net.oboki.kakaobank.recruit


mvn dependency:copy-dependencies

mvn package

java -cp target/codingtest-p4-1.0-SNAPSHOT.jar:target/dependency/* net.oboki.kakaobank.recruit.Test