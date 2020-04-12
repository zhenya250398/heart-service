package com.example.heart.repos;

import com.example.heart.domain.Heart;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface HeartRepo extends CrudRepository<Heart, Long> {

    List<Heart> findByText(String text);

}
