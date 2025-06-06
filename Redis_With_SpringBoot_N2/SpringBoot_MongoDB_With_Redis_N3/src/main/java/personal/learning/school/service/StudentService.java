package personal.learning.school.service;

import personal.learning.school.entity.Student;

public interface StudentService {

	Student getStudentDetails(String id);
	
	Student getStudentDetailsVersion2(String id);
	
}
