### [Main Tech Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/README.md)

----------

<a name="top"></a>

|                                             |                                                |
|---------------------------------------------|------------------------------------------------|
| [Maven Web Site](https://maven.apache.org/) | [Maven Repository](https://mvnrepository.com/) |

## Phases in Order of Execution
	- validate: Not defined
	- initialize: Not defined
	- generate-sources: Not defined
	- process-sources: Not defined
	- generate-resources: Not defined
	- process-resources: Not defined
	- compile: Not defined
	- process-classes: Not defined
	- generate-test-sources: Not defined
	- process-test-sources: Not defined
	- generate-test-resources: Not defined
	- process-test-resources: Not defined
	- test-compile: Not defined
	- process-test-classes: Not defined
	- test: Not defined
	- prepare-package: Not defined
	- package: Not defined
	- pre-integration-test: Not defined
	- integration-test: Not defined
	- post-integration-test: Not defined
	- verify: Not defined
	- install: org.apache.maven.plugins:maven-install-plugin:2.4:install
	- deploy: org.apache.maven.plugins:maven-deploy-plugin:2.7:deploy

### List Goals for Specified Phases
```bash
mvn fr.jcgay.maven.plugins:buildplan-maven-plugin:list -Dbuildplan.tasks=clean,deploy
```

### Display the Effective POM
```bash
mvn help:eeffective-pom
```

### Get Sources/Javadoc
#### Sources For All Dependencies
```bash
    mvn dependency:sources
```

#### Sources For a Specific Dependency
```bash
    mvn dependency:sources -DincludeGroupIds=com.example.api.agents -DincludeArtifactIds=api-agent-spark
```

#### Javadoc for All Dependencies
```bash
    mvn dependency:resolve -Dclassifier=javadoc
```

#### Sources and Javadoc for All Dependencies
```bash
    mvn dependency:sources dependency:resolve -Dclassifier=javadoc
```

#### Sources/Javadoc For a Specific Dependency
```bash
    mvn dependency:sources dependency:resolve -Dclassifier=javadoc -DincludeGroupIds=com.example.api.agents -DincludeArtifactIds=api-agent-spark
```

----------

### [Main Tech Tips Page](https://github.com/sethfuller/tips/blob/main/tech_tips/README.md)
