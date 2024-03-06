package io.github.angelogalvao.ocp.spring;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import io.dekorate.openshift.annotation.OpenshiftApplication;

@SpringBootApplication
@OpenshiftApplication(replicas = 3, expose = true) 
public class SpringBootExampleAppApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootExampleAppApplication.class, args);
	}

}
