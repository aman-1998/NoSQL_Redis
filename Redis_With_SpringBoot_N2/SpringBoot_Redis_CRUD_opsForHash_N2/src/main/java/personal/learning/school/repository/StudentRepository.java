package personal.learning.school.repository;

import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import personal.learning.school.entity.Student;

@Repository
public class StudentRepository {
	
	private static final String HASH_KEY = "STUDENT";
	
	@Autowired
	private RedisTemplate<String, Object> redisTemplate;

	public void save(Student student) {
		
		redisTemplate.opsForHash().put(HASH_KEY, student.getId(), student);
		
		// Optional: Set an expiry for the whole hash key
        // redisTemplate.expire(HASH_KEY, 5, TimeUnit.MINUTES);
	}

	public Student getStudentById(String id) {
		
		// HGET STUDENT 3e0ca08b-dec3-437e-9c0d-c307e4e0bf3d
		return (Student) redisTemplate.opsForHash().get(HASH_KEY, id);
	}

	public void deleteById(String id) throws Exception {
		
		if(redisTemplate.opsForHash().hasKey(HASH_KEY, id)) {
			redisTemplate.opsForHash().delete(HASH_KEY, id);
		} else {
			throw new Exception("id:" + id + " does not exist inside hash:" + HASH_KEY);
		}
	}

	public void updateById(String id, Student student) throws Exception {
		
		if(redisTemplate.opsForHash().hasKey(HASH_KEY, id)) {
			student.setId(id);
			redisTemplate.opsForHash().put(HASH_KEY, id, student);
		} else {
			throw new Exception("id:" + id + " does not exist inside hash:" + HASH_KEY);
		}
	}

}
