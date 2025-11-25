package com.example.OrderCoffeeBE.Service;



import com.example.OrderCoffeeBE.Model.RefreshToken;
import com.example.OrderCoffeeBE.Model.User;

import java.util.List;
import java.util.Optional;

public interface RefreshTokenService {
    Optional<RefreshToken> findByToken(String token);
    RefreshToken createRefreshToken(User user);
    RefreshToken verifyExpiration(RefreshToken token);
    RefreshToken useToken(RefreshToken token, String replacedByToken);
    void revokeToken(RefreshToken token, String reason);
    void deleteByUser(User user);
    List<RefreshToken> findActiveTokensByUser(User user);
    void purgeExpiredTokens();
}
