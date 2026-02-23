package com.model;

public class Project {

	private int projectId;
	private String projetName;
	private String description;
	
	public Project() {
		// TODO Auto-generated constructor stub
	}

	public Project(int projectId, String projetName, String description) {
		super();
		this.projectId = projectId;
		this.projetName = projetName;
		this.description = description;
	}

	public int getProjectId() {
		return projectId;
	}

	public void setProjectId(int projectId) {
		this.projectId = projectId;
	}

	public String getProjetName() {
		return projetName;
	}

	public void setProjetName(String projetName) {
		this.projetName = projetName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
	
}
