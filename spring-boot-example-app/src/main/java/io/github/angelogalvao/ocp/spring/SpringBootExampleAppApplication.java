package io.github.angelogalvao.ocp.spring;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import io.dekorate.openshift.annotation.OpenshiftApplication;
import io.dekorate.openshift.annotation.Route;

@SpringBootApplication
@OpenshiftApplication(replicas = 3, route = @Route(expose = true)) 
public class SpringBootExampleAppApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootExampleAppApplication.class, args);
	}

}
